# frozen_string_literal: true

module Mural
  class Widget
    class UpdateTextBoxParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/updatetextbox
      define_attributes(
        **Mural::Widget::CreateTextBoxParams.attrs.reject do |attr|
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
