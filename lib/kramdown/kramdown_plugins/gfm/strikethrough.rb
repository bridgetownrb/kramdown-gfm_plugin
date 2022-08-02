# frozen_string_literal: true

module Kramdown
  module KramdownPlugins
    module GFM
      module Strikethrough
        STRIKETHROUGH_DELIM = %r{~~}.freeze
        STRIKETHROUGH_MATCH = %r{#{STRIKETHROUGH_DELIM}(?!\s|~).*?[^\s~]#{STRIKETHROUGH_DELIM}}m.freeze

        def self.configure(klass, _source, _options)
          klass.define_parser :gfm_strikethrough, STRIKETHROUGH_MATCH, "~~"
        end

        def self.parsers(parser)
          parser.span_parsers << :gfm_strikethrough
        end

        module InstanceMethods
          def parse_gfm_strikethrough
            line_number = @src.current_line_number

            @src.pos += @src.matched_size
            el = Element.new(:html_element, "del", {}, category: :span, line: line_number)
            @tree.children << el

            env = save_env
            reset_env(src: Kramdown::Utils::StringScanner.new(@src.matched[2..-3], line_number),
                      text_type: :text)
            parse_spans(el)
            restore_env(env)

            el
          end
        end
      end
    end

    register_plugin GFM::Strikethrough
  end
end
