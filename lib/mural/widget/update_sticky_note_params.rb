# frozen_string_literal: true

module Mural
  class Widget
    class UpdateStickyNoteParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/updatestickynote
      define_attributes(
        **Mural::Widget::CreateStickyNoteParams.attrs.reject do |attr|
          %i[stacking_order shape].include? attr
        end
      )

      Style = Mural::Widget::StickyNote::Style

      def encode
        super.tap do |json|
          json['style'] = json['style']&.encode
        end
      end
    end
  end
end
