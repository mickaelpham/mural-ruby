# frozen_string_literal: true

module Mural
  class CreateTagParams
    include Mural::Codec

    define_attributes(
      # The text in the tag.
      text: 'text',

      # The background color of the tag in hex with alpha format.
      background_color: 'backgroundColor',

      # The border color of the tag in hex with alpha format.
      border_color: 'borderColor',

      # The text color of the tag in hex with alpha format.
      color: 'color',

      # The widgets to add the new tag to.
      #
      # ⚠️ This is rejected by Mural API with the following error:
      # > Invalid "widgets" property type was sent. Type undefined was expected.
      widgets: 'widgets'
    )

    def encode
      super.tap do |json|
        json['widgets']&.map!(&:encode)
      end
    end

    class Widget
      include Mural::Codec

      define_attributes(
        # The unique ID of the widget to add the new tag to.
        id: 'id',

        # Text size.
        font_size: 'fontSize'
      )
    end
  end
end
