# frozen_string_literal: true

require_relative "gfm_plugin/version"

require "kramdown/plugins"

module Kramdown
  module Options
    define(:gfm_hard_line_breaks, Boolean, false, <<~DESC)
      Interprets line breaks literally
      Insert HTML `<br />` tags inside paragraphs where the original Markdown
      document had newlines (by default, Markdown ignores these newlines).
      Default: false
      Used by: GFM plugin
    DESC

    define(:gfm_paragraph_end, Boolean, true, <<~DESC)
      Disables the kramdown restriction that at least one blank line has to
      be used after a paragraph before a new block element can be started.
      Note that if this quirk is used, lazy line wrapping does not fully
      work anymore!
      Default: true
      Used by: GFM plugin
    DESC
  end
end

require_relative "kramdown_plugins/gfm/codeblock"
require_relative "kramdown_plugins/gfm/strikethrough"
require_relative "kramdown_plugins/gfm/quirks"
