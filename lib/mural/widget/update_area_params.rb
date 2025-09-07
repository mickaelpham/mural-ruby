# frozen_string_literal: true

module Mural
  class Widget
    class UpdateAreaParams
      include Mural::Codec

      define_attributes(
        **Mural::Widget::CreateAreaParams.attrs
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
