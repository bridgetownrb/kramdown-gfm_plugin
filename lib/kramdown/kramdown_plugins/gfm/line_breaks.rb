# frozen_string_literal: true

module Kramdown
  module KramdownPlugins
    module GFM
      module LineBreaks
        def self.configure(*); end

        def self.parsers(*); end

        def self.after_parse(parser)
          @hard_line_break = "#{parser.options[:gfm_hard_line_breaks] ? "" : "\\"}\n"

          walk_elements_for_text(parser.root)
        end

        def self.walk_elements_for_text(element)
          element.children.map! do |child|
            if child.type == :text && child.value.include?(@hard_line_break)
              add_line_breaks(element, child)
            else
              walk_elements_for_text(child)
              child
            end
          end.flatten!
        end

        def self.add_line_breaks(element, child)
          children = []

          # split and be sure to capture the last blank line
          lines = child.value.split(@hard_line_break, -1)

          # determine if the trailing line needs a break or not
          omit_trailing_br = (
            lines[-1].empty? &&
              Kramdown::Element.category(element) == :block &&
              element.children[-1] == child
          )

          lines.each_with_index do |line, index|
            new_element_options = { location: child.options[:location] + index }

            # add the new line of text
            children << Element.new(:text, (index > 0 ? "\n#{line}" : line), nil, new_element_options)

            if index < lines.size - 2 || (index == lines.size - 2 && !omit_trailing_br)
              # add the <br />
              children << Element.new(:br, nil, nil, new_element_options)
            end
          end

          children
        end
      end
    end

    register_plugin GFM::LineBreaks
  end
end
