# frozen_string_literal: true

module Mural
  class Widget
    class CreateStickyNoteParams
      include Mural::Codec

      define_attributes(
        **Mural::Widget::StickyNote.attrs.filter do |attr|
          %i[
            height
            hidden
            html_text
            hyperlink
            hyperlink_title
            instruction
            parent_id
            presentation_index
            rotation
            shape
            stacking_order
            style
            tags
            text
            title
            width
            x
            y
          ].include?(attr)
        end
      )

      def encode
        super.tap do |json|
          json['style'] = json['style']&.encode
        end.compact
      end

      # Exact same values, no restrictions
      Style = Mural::Widget::StickyNote::Style
    end
  end
end
