# frozen_string_literal: true

module Kramdown
  module KramdownPlugins
    module GFM
      module Quirks
        PARAGRAPH_END_GFM = Regexp.union(
          Parser::Kramdown::LAZY_END, Parser::Kramdown::LIST_START, Parser::Kramdown::ATX_HEADER_START, Parser::Kramdown::DEFINITION_LIST_START,
          Parser::Kramdown::BLOCKQUOTE_START, Parser::Kramdown::FENCED_CODEBLOCK_START
        )

        def self.configure(klass, _source, _options)
          klass.alias_method :_old_paragraph_end, :paragraph_end
          klass.undef_method :paragraph_end
          klass.define_method :paragraph_end do
            @options[:gfm_paragraph_end] ? PARAGRAPH_END_GFM : _old_paragraph_end
          end
        end

        def self.parsers(parser)
          parser.span_parsers.delete(:line_break) if parser.options[:gfm_hard_line_breaks]
        end
      end
    end

    register_plugin GFM::Quirks
  end
end
