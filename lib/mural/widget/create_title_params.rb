# frozen_string_literal: true

module Mural
  class Widget
    class CreateTitleParams
      include Mural::Codec

      define_attributes(
        **Mural::Widget::Text.attrs.filter do |attr|
          %i[
            height
            hidden
            hyperlink
            hyperlink_title
            instruction
            parent_id
            presentation_index
            rotation
            stacking_order
            style
            text
            title
            width
            x
            y
          ].include? attr
        end
      )

      Style = Mural::Widget::Text::Style

      def encode
        super.tap do |json|
          json['style'] = json['style']&.encode
        end.compact
      end
    end
  end
end
