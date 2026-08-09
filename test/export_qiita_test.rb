require "minitest/autorun"
require "stringio"
require "tmpdir"
require "fileutils"

require_relative "../scripts/export-qiita"

class QiitaExporterTest < Minitest::Test
  def setup
    @root = Dir.mktmpdir("qiita-export-test")
    FileUtils.mkdir_p(File.join(@root, "_posts"))
    FileUtils.mkdir_p(File.join(@root, "qiita", "public"))
    File.write(File.join(@root, "_config.yml"), "url: https://example.com\n", encoding: "utf-8")
  end

  def teardown
    FileUtils.remove_entry(@root)
  end

  def test_exports_front_matter_links_html_and_footer_without_rewriting_code
    write_post("2026-08-07-related.md", <<~MARKDOWN)
      ---
      title: Related
      date: 2026-08-07
      ---
      Related body
    MARKDOWN
    path = write_post("2026-08-08-example.md", <<~MARKDOWN)
      ---
      title: "Example"
      date: 2026-08-08 00:00:00 +0900
      qiita:
        publish: true
        tags: [Ruby, Qiita]
      ---

      [用語](/terms/example/)
      ![画像](/assets/example.png)
      <a href="/about/">About</a>
      [関連記事]({% post_url 2026-08-07-related %})

      ```markdown
      [変換しない](/inside-code/)
      {% post_url 2026-08-07-related %}
      ```
    MARKDOWN

    exporter.run([path])
    output = read_output("example.md")

    assert_includes output, 'title: "Example"'
    assert_includes output, "  - \"Ruby\""
    assert_includes output, "[用語](https://example.com/terms/example/)"
    assert_includes output, "![画像](https://example.com/assets/example.png)"
    assert_includes output, '<a href="https://example.com/about/">About</a>'
    assert_includes output, "[関連記事](https://example.com/2026/08/07/related.html)"
    assert_includes output, "[変換しない](/inside-code/)"
    assert_includes output, "{% post_url 2026-08-07-related %}"
    assert_includes output, "https://example.com/2026/08/08/example.html"
    assert_equal 1, output.scan(QiitaExporter::FOOTER_MARKER).length
  end

  def test_preserves_cli_metadata_and_uses_custom_permalink
    write_output("example.md", qiita_document(id: "item-id", updated_at: "2026-08-08T10:00:00+09:00"))
    path = write_post("2026-08-08-example.md", <<~MARKDOWN)
      ---
      title: Example updated
      date: 2026-08-08
      permalink: /articles/:title/
      qiita:
        publish: true
        tags: [Ruby]
      ---
      Body
    MARKDOWN

    exporter.run([path])
    output = read_output("example.md")

    assert_includes output, 'id: "item-id"'
    assert_includes output, 'updated_at: "2026-08-08T10:00:00+09:00"'
    assert_includes output, "https://example.com/articles/example/"
  end

  def test_disables_existing_export_when_publish_is_false
    write_output("example.md", qiita_document(id: "item-id"))
    path = write_post("2026-08-08-example.md", <<~MARKDOWN)
      ---
      title: Example
      qiita:
        publish: false
        tags: [Ruby]
      ---
      Changed source body
    MARKDOWN

    exporter.run([path])
    output = read_output("example.md")

    assert_includes output, "ignorePublish: true"
    assert_includes output, "Existing body"
    refute_includes output, "Changed source body"
  end

  def test_check_reports_outdated_export_without_writing
    path = write_post("2026-08-08-example.md", <<~MARKDOWN)
      ---
      title: Example
      qiita:
        publish: true
        tags: [Ruby]
      ---
      Body
    MARKDOWN
    checker = QiitaExporter.new(root: @root, check: true, out: StringIO.new)

    error = assert_raises(QiitaExportError) { checker.run([path]) }

    assert_includes error.message, "out of date"
    refute File.exist?(File.join(@root, "qiita", "public", "example.md"))
  end

  def test_check_accepts_qiita_cli_formatting_for_equivalent_content
    path = write_post("2026-08-08-example.md", <<~MARKDOWN)
      ---
      title: Example
      qiita:
        publish: true
        tags: [Ruby]
      ---
      Body
    MARKDOWN
    exporter.run([path])
    output_path = File.join(@root, "qiita", "public", "example.md")
    cli_style = File.read(output_path, encoding: "utf-8")
      .sub('title: "Example"', "title: Example")
      .sub('  - "Ruby"', "  - Ruby")
      .sub('updated_at: ""', "updated_at: ''")
      .sub("---\n\nBody", "---\nBody")
    File.write(output_path, cli_style, encoding: "utf-8")
    checker = QiitaExporter.new(root: @root, check: true, out: StringIO.new)

    assert_empty checker.run([path])
  end

  def test_dry_run_reports_change_without_writing
    path = write_post("2026-08-08-example.md", <<~MARKDOWN)
      ---
      title: Example
      qiita:
        publish: true
        tags: [Ruby]
      ---
      Body
    MARKDOWN
    output = StringIO.new
    dry_runner = QiitaExporter.new(root: @root, dry_run: true, out: output)

    dry_runner.run([path])

    assert_includes output.string, "would write qiita/public/example.md"
    refute File.exist?(File.join(@root, "qiita", "public", "example.md"))
  end

  def test_disables_orphaned_export_during_full_run
    write_output("orphan.md", qiita_document(id: "item-id"))

    exporter.run

    assert_includes read_output("orphan.md"), "ignorePublish: true"
  end

  def test_rejects_empty_duplicate_and_too_many_tags
    [
      "[]",
      "[Ruby, Ruby]",
      "[one, two, three, four, five, six]"
    ].each do |tags|
      path = write_post("2026-08-08-example.md", <<~MARKDOWN)
        ---
        title: Example
        qiita:
          publish: true
          tags: #{tags}
        ---
        Body
      MARKDOWN

      assert_raises(QiitaExportError) { exporter.run([path]) }
    end
  end

  private

  def exporter
    QiitaExporter.new(root: @root, out: StringIO.new)
  end

  def write_post(name, content)
    path = File.join(@root, "_posts", name)
    File.write(path, content, encoding: "utf-8")
    path
  end

  def write_output(name, content)
    File.write(File.join(@root, "qiita", "public", name), content, encoding: "utf-8")
  end

  def read_output(name)
    File.read(File.join(@root, "qiita", "public", name), encoding: "utf-8")
  end

  def qiita_document(id:, updated_at: "")
    <<~MARKDOWN
      ---
      title: "Existing"
      tags:
        - "Ruby"
      private: false
      updated_at: "#{updated_at}"
      id: #{id.nil? ? 'null' : "\"#{id}\""}
      organization_url_name: null
      slide: false
      ignorePublish: false
      posting_campaign_uuid: null
      agreed_posting_campaign_term: false
      ---

      Existing body
    MARKDOWN
  end
end
