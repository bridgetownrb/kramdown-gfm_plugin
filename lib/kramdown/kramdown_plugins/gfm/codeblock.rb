# frozen_string_literal: true

require "digest/sha2"

module Kramdown
  module KramdownPlugins
    module GFM
      module Codeblock
        FENCED_CODEBLOCK_MATCH = %r{^ {0,3}(([~`]){3,})\s*?((.+?)(?:\?\S*)?)?\s*?\n(.*?)^ {0,3}\1\2*\s*?\n}m.freeze

        def self.configure(*); end

        def self.parsers(parser)
          return if parser.root.respond_to?(:extractions)

          parser.root.singleton_class.define_method :extractions do
            @extractions ||= []
          end
        end

        def self.fenced_codeblock_extension
          :handle_gfm_codeblock
        end

        module InstanceMethods
          def handle_gfm_codeblock
            return unless @src.check(GFM::Codeblock::FENCED_CODEBLOCK_MATCH)

            start_line_number = @src.current_line_number

            # Advance the parsing position
            @src.pos += @src.matched_size

            if @src[3].to_s.strip.include?(" ")
              handle_code_with_extractions start_line_number
            else
              handle_standard_codeblock start_line_number
            end

            throw :codeblock_processed, true
          end

          def handle_standard_codeblock(start_line_number)
            el = new_block_el(:codeblock, @src[5], nil, location: start_line_number, fenced: true)
            lang = @src[3].to_s.strip
            unless lang.empty?
              el.options[:lang] = lang
              el.attr["class"] = "language-#{@src[4]}"
            end
            @tree.children << el
          end

          def handle_code_with_extractions(start_line_number) # rubocop:todo Metrics
            lang = @src[3].to_s.strip
            lang = lang.split

            sha = Digest::SHA2.hexdigest(@src[5])
            root.extractions << {
              sha: sha,
              lang: lang[0],
              meta: lang[1],
              code: @src[5],
              start_line_number: start_line_number
            }

            return if options[:include_extraction_tags] == false

            el = Element.new(
              :html_element,
              "kramdown-extraction",
              {
                id: "ex-#{sha}",
                lang: lang[0],
                meta: lang[1]
              },
              category: :block,
              location: start_line_number,
              content_model: :raw
            )

            unless options[:include_code_in_extractions] == false
              code_el = new_block_el(:codeblock, @src[5], nil, location: start_line_number, fenced: true)
              code_el.options[:lang] = lang[0]
              code_el.attr["class"] = "language-#{lang[0]}"
              el.children << Element.new(
                :html_element,
                "template",
                nil,
                category: :block,
                location: start_line_number,
                content_model: :raw
              ).tap do |tmpl|
                tmpl.children << code_el
              end
            end

            @tree.children << el
          end
        end
      end
    end

    register_plugin GFM::Codeblock
  end
end
