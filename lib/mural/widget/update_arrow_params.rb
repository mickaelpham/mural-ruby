# frozen_string_literal: true

module Mural
  class Widget
    class UpdateArrowParams
      include Mural::Codec

      define_attributes(
        **Mural::Widget::CreateArrowParams.attrs.reject do |attr|
          %i[stacking_order].include? attr
        end
      )

      def encode
        super.tap do |json|
          json['points']&.map!(&:encode)
          json['label'] = json['label']&.encode
          json['style'] = json['style']&.encode
        end
      end

      Style = Mural::Widget::Arrow::Style
      Label = Mural::Widget::Arrow::Label
      Point = Mural::Widget::Arrow::Point
    end
  end
end
