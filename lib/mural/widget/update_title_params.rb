# frozen_string_literal: true

module Mural
  class Widget
    class UpdateTitleParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/updatetitle
      define_attributes(
        **Mural::Widget::CreateTitleParams.attrs.reject do |attr|
          %i[stacking_order].include? attr
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
