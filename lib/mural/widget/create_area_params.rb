# frozen_string_literal: true

module Mural
  class Widget
    class CreateAreaParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/createarea
      define_attributes(
        **Mural::Widget::Area.attrs.filter do |attr|
          %i[
            height
            hidden
            instruction
            layout
            parent_id
            presentation_index
            show_title
            stacking_order
            style
            title
            width
            x
            y
          ].include? attr
        end
      )

      Style = Mural::Widget::Area::Style

      def encode
        super.tap do |json|
          json['style'] = json['style']&.encode
        end
      end
    end
  end
end
