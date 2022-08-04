# frozen_string_literal: true

require "test_helper"

class Kramdown::TestGfmPlugin < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Kramdown::GfmPlugin::VERSION
  end

  def setup
    @text = <<~MD
      # Regular Markdown Here

      *More ~~Markdown~~ continues...*

      That's pretty ~~awesome~~.
      Test lines
    MD
  end

  def test_correct_output
    doc = Kramdown::Document.new(@text, { input: :PluginsParser })
    html = doc.to_html

    assert_equal 2, html.scan("<del>").size
    assert_equal 1, html.scan("</del>.\nTest").size

    doc2 = Kramdown::Document.new(@text, { input: :PluginsParser, gfm_hard_line_breaks: true })
    html2 = doc2.to_html

    assert_equal 1, html2.scan("</del>.<br />\nTest").size
  end

  def test_gfm_code
    new_text = <<~MD
      Hello--world.

      This is.
      A lot of lines?

      A paragraph.
      > Wee
      Nice!

      ```ruby script
      @a = 123
      ```

      # Heading

      # Head	ing
      Wee wa.

      ```js
      const b = 456
      ```
    MD

    doc = Kramdown::Document.new(new_text, { input: :PluginsParser })
    html = doc.to_html

    assert_equal 1, html.scan('<pre><code class="language-js">const b = 456').size
    assert_equal 1, html.scan('<template>    <pre><code class="language-ruby">@a = 123').size
    assert_equal(
      { sha: "428c76d021ebce1c4db6ba495dae96783142812ea45eb049f467515bef1eb22e", lang: "ruby", meta: "script",
        code: "@a = 123\n", start_line_number: 10 }, doc.root.extractions[0]
    )
  end
end
