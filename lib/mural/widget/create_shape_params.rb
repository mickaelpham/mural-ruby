# frozen_string_literal: true

module Mural
  class Widget
    class CreateShapeParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/createshapewidget
      define_attributes(
        **Mural::Widget::Shape.attrs.filter do |attr|
          %i[
            height
            hidden
            html_text
            instruction
            parent_id
            presentation_index
            rotation
            shape
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

      Style = Mural::Widget::Shape::Style

      def encode
        super.tap do |json|
          json['style'] = json['style']&.encode
        end.compact
      end
    end
  end
end
