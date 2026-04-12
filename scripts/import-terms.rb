#!/usr/bin/env ruby

require "optparse"
require_relative "lib/importer_support"

class TermImporter < MarkdownImporterBase
  def initialize(source_dir:, output_dir:, dry_run: false)
    super(
      source_dir: source_dir,
      output_dir: output_dir,
      dry_run: dry_run,
      term_index_source_dir: source_dir
    )
  end

  private

  def eligible?(data)
    data["type"] == "term" && data["publish"] == true
  end

  def render_output(data, body)
    title = required_string!(data, "title")
    slug = required_string!(data, "slug")
    sort_key = optional_string(data["sort_key"]) || slug
    summary = optional_string(data["summary"])
    category = optional_string(data["category"])
    aliases = Array(data["aliases"]).filter_map { |alias_name| optional_string(alias_name) }
    updated = extract_date(data["updated"] || data["created"], "updated or created")
    output_body = convert_wiki_links(strip_matching_h1(body, title))

    lines = ["---"]
    lines << %(title: #{yaml_string(title)})
    lines << %(slug: #{yaml_string(slug)})
    lines << %(sort_key: #{yaml_string(sort_key)})
    lines << %(summary: #{yaml_string(summary)}) unless summary.nil? || summary.empty?
    lines << %(category: #{yaml_string(category)}) unless category.nil? || category.empty?
    lines << %(aliases: #{JSON.generate(aliases)}) unless aliases.empty?
    lines << %(updated: #{updated.strftime("%Y-%m-%d")})
    lines << "---"
    lines << ""
    lines << output_body.rstrip
    lines << ""
    lines.join("\n")
  end
end

script_dir = __dir__
blog_root = File.expand_path("..", script_dir)
default_vault_root = File.expand_path("../../knowledge-vault-work", script_dir)

options = {
  source_dir: File.join(default_vault_root, "01_terms"),
  output_dir: File.join(blog_root, "_terms"),
  dry_run: false
}

OptionParser.new do |parser|
  parser.banner = "Usage: ruby scripts/import-terms.rb [options]"

  parser.on("--source-dir PATH", "Path to knowledge-vault 01_terms directory") do |value|
    options[:source_dir] = value
  end

  parser.on("--output-dir PATH", "Path to Jekyll _terms directory") do |value|
    options[:output_dir] = value
  end

  parser.on("--dry-run", "Show what would change without writing files") do
    options[:dry_run] = true
  end
end.parse!

TermImporter.new(**options).run
