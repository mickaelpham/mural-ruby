# frozen_string_literal: true

module Mural
  class Widget
    class UpdateShapeParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/updateshapewidget
      define_attributes(
        **Mural::Widget::CreateShapeParams.attrs.reject do |attr|
          %i[shape stacking_order].include? attr
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
