# frozen_string_literal: true

module Mural
  class Widget
    class UpdateAreaParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/updatearea
      define_attributes(
        **Mural::Widget::CreateAreaParams.attrs.reject do |attr|
          %i[stacking_order].include? attr
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
