#!/usr/bin/env ruby

require "date"
require "fileutils"
require "json"
require "optparse"
require "set"
require "yaml"

class QiitaExportError < StandardError; end

class QiitaExporter
  FOOTER_MARKER = "この記事は[Reo's Tech Blogの同名記事]".freeze
  QIITA_FIELDS = %w[
    title tags private updated_at id organization_url_name slide ignorePublish
    posting_campaign_uuid agreed_posting_campaign_term
  ].freeze

  def initialize(root:, dry_run: false, check: false, out: $stdout)
    @root = File.expand_path(root)
    @posts_dir = File.join(@root, "_posts")
    @output_dir = File.join(@root, "qiita", "public")
    @dry_run = dry_run
    @check = check
    @out = out
    raise QiitaExportError, "--dry-run and --check cannot be used together" if dry_run && check

    site_config = load_yaml(File.join(@root, "_config.yml"))
    @site_url = site_config.fetch("url", "").to_s.sub(%r{/+\z}, "")
    raise QiitaExportError, "_config.yml: url must be an absolute HTTPS URL" unless @site_url.match?(%r{\Ahttps://[^/]+})
  end

  def run(requested_paths = [])
    post_paths = resolve_post_paths(requested_paths)
    known_slugs = post_paths.to_h { |path| [slug_for(path), path] }
    changed = []

    post_paths.each do |path|
      output_path = output_path_for(path)
      document = parse_document(path)
      qiita = document.fetch(:data)["qiita"]

      if qiita.is_a?(Hash) && qiita["publish"] == true
        tags = validate_tags!(qiita["tags"], path)
        existing = File.exist?(output_path) ? parse_document(output_path) : nil
        output = render_published(document, path, tags, existing)
        changed << output_path if apply_change(output_path, output)
      elsif File.exist?(output_path)
        existing = parse_document(output_path)
        output = render_qiita_document(existing.fetch(:data).merge("ignorePublish" => true), existing.fetch(:body))
        changed << output_path if apply_change(output_path, output)
      end
    end

    if requested_paths.empty?
      Dir.glob(File.join(@output_dir, "*.md")).sort.each do |output_path|
        next if known_slugs.key?(File.basename(output_path, ".md"))

        existing = parse_document(output_path)
        output = render_qiita_document(existing.fetch(:data).merge("ignorePublish" => true), existing.fetch(:body))
        changed << output_path if apply_change(output_path, output)
      end
    end

    if @check && changed.any?
      raise QiitaExportError, "Qiita exports are out of date: #{changed.map { |path| relative(path) }.join(', ')}"
    end

    @out.puts(changed.empty? ? "Qiita exports are up to date." : "Updated #{changed.length} Qiita export(s).")
    changed
  end

  private

  def resolve_post_paths(requested_paths)
    return Dir.glob(File.join(@posts_dir, "*.md")).sort if requested_paths.empty?

    requested_paths.map do |requested|
      path = File.expand_path(requested, @root)
      unless path.start_with?(@posts_dir + File::SEPARATOR) && File.file?(path)
        raise QiitaExportError, "post not found under _posts: #{requested}"
      end
      path
    end.uniq.sort
  end

  def parse_document(path)
    content = File.read(path, encoding: "utf-8")
    parse_content(content, relative(path))
  end

  def parse_content(content, label)
    match = content.match(/\A---\s*\n(.*?)\n---\s*\n?(.*)\z/m)
    raise QiitaExportError, "missing front matter: #{label}" unless match

    data = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: false) || {}
    raise QiitaExportError, "front matter must be a mapping: #{label}" unless data.is_a?(Hash)

    { data: data, body: match[2].to_s }
  rescue Psych::SyntaxError => e
    raise QiitaExportError, "invalid front matter: #{label}: #{e.message}"
  end

  def load_yaml(path)
    YAML.safe_load_file(path, permitted_classes: [Date, Time], aliases: false) || {}
  rescue Psych::SyntaxError => e
    raise QiitaExportError, "invalid YAML: #{relative(path)}: #{e.message}"
  end

  def slug_for(path)
    match = File.basename(path).match(/\A\d{4}-\d{2}-\d{2}-(.+)\.md\z/)
    raise QiitaExportError, "invalid post filename: #{relative(path)}" unless match
    match[1]
  end

  def output_path_for(path)
    File.join(@output_dir, "#{slug_for(path)}.md")
  end

  def validate_tags!(value, path)
    unless value.is_a?(Array) && value.length.between?(1, 5)
      raise QiitaExportError, "#{relative(path)}: qiita.tags must contain 1 to 5 tags"
    end

    tags = value.map { |tag| tag.is_a?(String) ? tag.strip : "" }
    raise QiitaExportError, "#{relative(path)}: qiita.tags cannot contain empty values" if tags.any?(&:empty?)
    raise QiitaExportError, "#{relative(path)}: qiita.tags cannot contain duplicates" if tags.to_set.length != tags.length
    tags
  end

  def render_published(document, path, tags, existing)
    source = document.fetch(:data)
    title = source["title"].to_s.strip
    raise QiitaExportError, "#{relative(path)}: title is required" if title.empty?

    old = existing ? existing.fetch(:data) : {}
    data = {
      "title" => title,
      "tags" => tags,
      "private" => false,
      "updated_at" => old.fetch("updated_at", ""),
      "id" => old["id"],
      "organization_url_name" => nil,
      "slide" => false,
      "ignorePublish" => false,
      "posting_campaign_uuid" => nil,
      "agreed_posting_campaign_term" => false
    }

    body = rewrite_links(document.fetch(:body))
    body = append_footer(body, canonical_url(source, path))
    render_qiita_document(data, body)
  end

  def canonical_url(data, path)
    date = post_date(data["date"], path)
    slug = slug_for(path)
    permalink = data["permalink"].to_s.strip
    permalink = "/:year/:month/:day/:title.html" if permalink.empty?
    replacements = {
      ":year" => date.strftime("%Y"),
      ":month" => date.strftime("%m"),
      ":day" => date.strftime("%d"),
      ":title" => slug
    }
    post_path = replacements.reduce(permalink) { |value, (key, replacement)| value.gsub(key, replacement) }
    post_path = "/#{post_path}" unless post_path.start_with?("/")
    "#{@site_url}#{post_path}"
  end

  def post_date(value, path)
    return value.to_date if value.respond_to?(:to_date)
    return Date.parse(value) if value.is_a?(String)

    Date.strptime(File.basename(path)[0, 10], "%Y-%m-%d")
  rescue Date::Error => e
    raise QiitaExportError, "#{relative(path)}: invalid date: #{e.message}"
  end

  def rewrite_links(body)
    in_fence = false
    fence_character = nil
    fence_length = nil

    body.lines.map do |line|
      if (match = line.match(/^\s*(`{3,}|~{3,})/))
        marker = match[1]
        if !in_fence
          in_fence = true
          fence_character = marker[0]
          fence_length = marker.length
        elsif marker[0] == fence_character && marker.length >= fence_length
          in_fence = false
        end
        next line
      end

      next line if in_fence

      rewritten = line.gsub(/(\]\()\/(?!\/)/, "\\1#{@site_url}/")
      rewritten = rewritten.gsub(/^(\s*\[[^\]]+\]:\s*)\/(?!\/)/, "\\1#{@site_url}/")
      rewritten.gsub(/((?:href|src)=[\"'])\/(?!\/)/i, "\\1#{@site_url}/")
    end.join
  end

  def append_footer(body, canonical_url)
    clean_body = body.rstrip
    footer_pattern = /\n---\n\n#{Regexp.escape(FOOTER_MARKER)}.*\z/m
    clean_body = clean_body.sub(footer_pattern, "")
    footer = <<~MARKDOWN.rstrip
      ---

      この記事は[Reo's Tech Blogの同名記事](#{canonical_url})にも掲載しています。

      Reo's Tech Blogでは、個人開発や日々の技術的な取り組みを記録しています。興味がありましたら、[ほかの記事もご覧ください](#{@site_url}/)。
    MARKDOWN
    "#{clean_body}\n\n#{footer}\n"
  end

  def render_qiita_document(data, body)
    unknown = data.keys.map(&:to_s) - QIITA_FIELDS
    raise QiitaExportError, "unsupported Qiita front matter fields: #{unknown.join(', ')}" if unknown.any?

    lines = ["---"]
    lines << "title: #{yaml_scalar(data['title'])}"
    lines << "tags:"
    Array(data["tags"]).each { |tag| lines << "  - #{yaml_scalar(tag)}" }
    lines << "private: #{data['private'] == true}"
    lines << "updated_at: #{yaml_scalar(data['updated_at'].to_s)}"
    lines << "id: #{data['id'].nil? ? 'null' : yaml_scalar(data['id'].to_s)}"
    lines << "organization_url_name: #{data['organization_url_name'].nil? ? 'null' : yaml_scalar(data['organization_url_name'].to_s)}"
    lines << "slide: #{data['slide'] == true}"
    lines << "ignorePublish: #{data['ignorePublish'] == true}"
    lines << "posting_campaign_uuid: #{data['posting_campaign_uuid'].nil? ? 'null' : yaml_scalar(data['posting_campaign_uuid'].to_s)}"
    lines << "agreed_posting_campaign_term: #{data['agreed_posting_campaign_term'] == true}"
    lines << "---"
    lines << ""
    lines << body.rstrip
    lines << ""
    lines.join("\n")
  end

  def yaml_scalar(value)
    JSON.generate(value)
  end

  def apply_change(path, output)
    existing = File.exist?(path) ? File.read(path, encoding: "utf-8") : nil
    return false if existing == output
    return false if existing && documents_equivalent?(existing, output, relative(path))

    @out.puts("#{@check ? 'outdated' : @dry_run ? 'would write' : 'write'} #{relative(path)}")
    unless @dry_run || @check
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, output, encoding: "utf-8")
    end
    true
  end

  def documents_equivalent?(existing, output, label)
    current = parse_content(existing, label)
    expected = parse_content(output, "generated #{label}")
    current.fetch(:data) == expected.fetch(:data) && current.fetch(:body).rstrip == expected.fetch(:body).rstrip
  rescue QiitaExportError
    false
  end

  def relative(path)
    path.delete_prefix(@root + File::SEPARATOR)
  end
end

if $PROGRAM_NAME == __FILE__
  options = { dry_run: false, check: false }
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: ruby scripts/export-qiita.rb [--dry-run|--check] [POST...]"
    opts.on("--dry-run", "Show changes without writing files") { options[:dry_run] = true }
    opts.on("--check", "Fail when generated files are out of date") { options[:check] = true }
  end

  begin
    paths = parser.parse(ARGV)
    root = File.expand_path("..", __dir__)
    QiitaExporter.new(root: root, **options).run(paths)
  rescue OptionParser::ParseError, QiitaExportError => e
    warn e.message
    exit 1
  end
end
