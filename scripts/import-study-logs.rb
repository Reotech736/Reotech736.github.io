#!/usr/bin/env ruby

require "optparse"
require_relative "lib/importer_support"

class StudyLogImporter < MarkdownImporterBase
  DEFAULT_TIMEZONE = "+0900"

  def initialize(source_dir:, output_dir:, terms_source_dir:, dry_run: false)
    super(
      source_dir: source_dir,
      output_dir: output_dir,
      dry_run: dry_run,
      term_index_source_dir: terms_source_dir
    )
  end

  private

  def eligible?(data)
    data["type"] == "study-log" && data["publish"] == true
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
