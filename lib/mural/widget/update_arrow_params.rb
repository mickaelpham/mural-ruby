# frozen_string_literal: true

module Mural
  class Widget
    class UpdateArrowParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/updatearrow
      define_attributes(
        **Mural::Widget::CreateArrowParams.attrs.reject do |attr|
          %i[stacking_order].include? attr
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
