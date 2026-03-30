#!/usr/bin/env ruby

require "date"
require "cgi"
require "fileutils"
require "json"
require "optparse"
require "yaml"

class StudyLogImporter
  DEFAULT_TIMEZONE = "+0900"

  def initialize(source_dir:, output_dir:, terms_source_dir:, dry_run: false)
    @source_dir = File.expand_path(source_dir)
    @output_dir = File.expand_path(output_dir)
    @terms_source_dir = File.expand_path(terms_source_dir)
    @dry_run = dry_run
    @imported = 0
    @updated = 0
    @removed = 0
    @skipped = 0
  end

  def run
    FileUtils.mkdir_p(@output_dir) unless @dry_run
    @term_index = build_term_index

    source_paths.sort.each do |source_path|
      document = parse_document(source_path)
      next unless document

      unless eligible?(document[:data])
        remove_output_for(source_path)
        @skipped += 1
        next
      end

      begin
        output_path = File.join(@output_dir, File.basename(source_path))
        output = render_output(document[:data], document[:body])
        write_if_changed(output_path, output)
        @imported += 1
      rescue ArgumentError => e
        warn "skip: #{source_path}: #{e.message}"
        @skipped += 1
      end
    end

    puts "imported=#{@imported} updated=#{@updated} removed=#{@removed} skipped=#{@skipped}"
  end

  private

  def source_paths
    Dir.glob(File.join(@source_dir, "*.md"))
  end

  def parse_document(path)
    content = File.read(path, encoding: "utf-8")
    match = content.match(/\A---\s*\n(.*?)\n---\s*\n?(.*)\z/m)

    unless match
      warn "skip: missing front matter: #{path}"
      @skipped += 1
      return nil
    end

    data = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: false) || {}
    body = match[2].to_s

    { path: path, data: data, body: body }
  rescue Psych::SyntaxError => e
    warn "skip: invalid front matter: #{path}: #{e.message}"
    @skipped += 1
    nil
  end

  def eligible?(data)
    data["type"] == "study-log" && data["publish"] == true
  end

  def remove_output_for(source_path)
    output_path = File.join(@output_dir, File.basename(source_path))
    return unless File.exist?(output_path)

    if @dry_run
      puts "remove #{relative_to_output(output_path)}"
    else
      File.delete(output_path)
      puts "remove #{relative_to_output(output_path)}"
    end
    @removed += 1
  end

  def render_output(data, body)
    title = required_string!(data, "title")
    slug = required_string!(data, "slug")
    study_date = extract_date(data["study_date"] || data["created"], "study_date or created")
    summary = optional_string(data["summary"])

    output_body = convert_wiki_links(strip_matching_h1(body, title))

    lines = ["---"]
    lines << %(title: #{yaml_string(title)})
    lines << %(date: #{study_date.strftime("%Y-%m-%d")} 00:00:00 #{DEFAULT_TIMEZONE})
    lines << %(slug: #{yaml_string(slug)})
    lines << %(summary: #{yaml_string(summary)}) unless summary.nil? || summary.empty?
    lines << "---"
    lines << ""
    lines << output_body.rstrip
    lines << ""
    lines.join("\n")
  end

  def write_if_changed(path, output)
    existing = File.exist?(path) ? File.read(path, encoding: "utf-8") : nil
    return if existing == output

    if @dry_run
      puts "write #{relative_to_output(path)}"
    else
      File.write(path, output, encoding: "utf-8")
      puts "write #{relative_to_output(path)}"
    end
    @updated += 1
  end

  def strip_matching_h1(body, title)
    trimmed = body.sub(/\A\s+/, "")
    first_line, rest = trimmed.split("\n", 2)
    return trimmed if first_line.nil?

    heading = first_line.match(/\A#\s+(.*)\z/)
    return trimmed unless heading
    return trimmed unless heading[1].strip == title.strip

    rest.to_s.sub(/\A\s*\n/, "")
  end

  def build_term_index
    index = {}

    Dir.glob(File.join(@terms_source_dir, "*.md")).sort.each do |path|
      document = parse_document(path)
      next unless document

      data = document[:data]
      title = optional_string(data["title"])
      slug = optional_string(data["slug"])
      next if title.nil? || title.empty? || slug.nil? || slug.empty?

      entry = {
        "title" => title,
        "slug" => slug,
        "published" => data["publish"] == true
      }

      index[normalize_term_key(title)] = entry
      index[normalize_term_key(slug)] = entry

      Array(data["aliases"]).each do |alias_name|
        normalized = normalize_term_key(alias_name)
        next if normalized.empty?
        index[normalized] = entry
      end
    end

    index
  end

  def convert_wiki_links(text)
    text.gsub(/\[\[([^\]]+)\]\]/) do
      raw = Regexp.last_match(1).strip
      target, label = raw.split("|", 2)
      target_name = target.to_s.split("#", 2).first.to_s.strip
      display_label = optional_string(label) || target_name
      entry = @term_index[normalize_term_key(target_name)]

      if entry && entry["published"]
        "[#{display_label}](/terms/#{entry["slug"]}/)"
      else
        %(<span class="pending-term" title="技術メモ準備中">#{CGI.escapeHTML(display_label)}</span>)
      end
    end
  end

  def normalize_term_key(value)
    value.to_s.strip.downcase
  end

  def extract_date(value, label)
    case value
    when Date
      value
    when Time
      value.to_date
    when String
      Date.parse(value)
    else
      raise ArgumentError, "missing or invalid #{label}"
    end
  rescue Date::Error => e
    raise ArgumentError, "invalid #{label}: #{e.message}"
  end

  def required_string!(data, key)
    value = optional_string(data[key])
    raise ArgumentError, "missing #{key}" if value.nil? || value.empty?

    value
  end

  def optional_string(value)
    return nil if value.nil?

    value.to_s.strip
  end

  def yaml_string(value)
    JSON.generate(value)
  end

  def relative_to_output(path)
    path.delete_prefix(@output_dir + "/")
  end
end

script_dir = __dir__
blog_root = File.expand_path("..", script_dir)
default_vault_root = File.expand_path("../../knowledge-vault-work", script_dir)

options = {
  source_dir: File.join(default_vault_root, "03_study_logs"),
  output_dir: File.join(blog_root, "_study_logs"),
  terms_source_dir: File.join(default_vault_root, "01_terms"),
  dry_run: false
}

OptionParser.new do |parser|
  parser.banner = "Usage: ruby scripts/import-study-logs.rb [options]"

  parser.on("--source-dir PATH", "Path to knowledge-vault 03_study_logs directory") do |value|
    options[:source_dir] = value
  end

  parser.on("--output-dir PATH", "Path to Jekyll _study_logs directory") do |value|
    options[:output_dir] = value
  end

  parser.on("--terms-source-dir PATH", "Path to knowledge-vault 01_terms directory") do |value|
    options[:terms_source_dir] = value
  end

  parser.on("--dry-run", "Show what would change without writing files") do
    options[:dry_run] = true
  end
end.parse!

StudyLogImporter.new(**options).run
