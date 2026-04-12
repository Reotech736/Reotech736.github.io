require "date"
require "cgi"
require "fileutils"
require "json"
require "yaml"

module ImporterSupport
  def source_paths(dir = @source_dir)
    Dir.glob(File.join(dir, "*.md"))
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

  def remove_output_for(source_path)
    output_path = output_path_for(source_path)
    return unless File.exist?(output_path)

    if @dry_run
      puts "remove #{relative_to_output(output_path)}"
    else
      File.delete(output_path)
      puts "remove #{relative_to_output(output_path)}"
    end
    @removed += 1
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

  def build_term_index(source_dir)
    index = {}

    source_paths(source_dir).sort.each do |path|
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

  def output_path_for(source_path)
    File.join(@output_dir, File.basename(source_path))
  end
end

class MarkdownImporterBase
  include ImporterSupport

  def initialize(source_dir:, output_dir:, dry_run: false, term_index_source_dir: nil)
    @source_dir = File.expand_path(source_dir)
    @output_dir = File.expand_path(output_dir)
    @dry_run = dry_run
    @term_index_source_dir = term_index_source_dir && File.expand_path(term_index_source_dir)
    @imported = 0
    @updated = 0
    @removed = 0
    @skipped = 0
  end

  def run
    FileUtils.mkdir_p(@output_dir) unless @dry_run
    @term_index = @term_index_source_dir ? build_term_index(@term_index_source_dir) : {}

    source_paths.sort.each do |source_path|
      document = parse_document(source_path)
      next unless document

      unless eligible?(document[:data])
        remove_output_for(source_path)
        @skipped += 1
        next
      end

      begin
        output = render_output(document[:data], document[:body])
        write_if_changed(output_path_for(source_path), output)
        @imported += 1
      rescue ArgumentError => e
        warn "skip: #{source_path}: #{e.message}"
        @skipped += 1
      end
    end

    puts "imported=#{@imported} updated=#{@updated} removed=#{@removed} skipped=#{@skipped}"
  end

  private

  def eligible?(_data)
    raise NotImplementedError, "#{self.class} must implement eligible?"
  end

  def render_output(_data, _body)
    raise NotImplementedError, "#{self.class} must implement render_output"
  end
end
