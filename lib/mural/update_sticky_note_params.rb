# frozen_string_literal: true

module Mural
  class UpdateStickyNoteParams
    include Mural::Codec

    define_attributes(
      **Mural::CreateStickyNoteParams.attrs.reject do |attr|
        %i[
          stacking_order
          shape
        ].include?(attr)
      end
    )

    def encode
      super.tap do |json|
        json['style'] = json['style']&.encode
      end
    end

    Style = Mural::Widget::StickyNote::Style
  end
end
