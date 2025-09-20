# frozen_string_literal: true

module Mural
  class Widget
    class CreateArrowParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/createarrow
      define_attributes(
        **Mural::Widget::Arrow.attrs.filter do |attr|
          %i[
            arrow_type
            end_ref_id
            height
            instruction
            label
            parent_id
            points
            presentation_index
            rotation
            stackable
            stacking_order
            start_ref_id
            style
            tip
            title
            width
            x
            y
          ].include? attr
        end
      )

      Style = Mural::Widget::Arrow::Style
      Label = Mural::Widget::Arrow::Label
      Point = Mural::Widget::Arrow::Point

      def encode
        super.tap do |json|
          json['points']&.map!(&:encode)
          json['label'] = json['label']&.encode
          json['style'] = json['style']&.encode
        end
      end
    end
  end
end
