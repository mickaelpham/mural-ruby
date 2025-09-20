# frozen_string_literal: true

module Mural
  class Widget
    class Image
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        # The aspect ratio of the image.
        aspect_ratio: 'aspectRatio',

        # If true, a border is displayed around the image.
        border: 'border',

        # The caption of the image.
        caption: 'caption',

        # The description of the image.
        description: 'description',

        # The number of minutes after which the image URL may expire.
        # May be null when download restriction is enabled.
        expires_in_minutes: 'expiresInMinutes',

        # The URL of the image link.
        link: 'link',

        # Mask object
        mask: 'mask',

        # The uncropped height of the image.
        natural_height: 'naturalHeight',

        # The uncropped width of the image.
        natural_width: 'naturalWidth',

        # If true, the caption and description are visible.
        show_caption: 'showCaption',

        # The URL of the image thumbnail.
        thumbnail_url: 'thumbnailUrl',

        # The download URL of the image. This URL has expiration time.
        # May be null when download restriction is enabled.
        url: 'url'
      )

      def self.decode(json)
        super.tap do |image|
          image.mask = Mask.decode(image.mask)
        end
      end

      class Mask
        include Mural::Codec

        define_attributes(
          # The vertical offset of the cropping mask from the upper-left corner
          # of the image.
          top: 'top',

          # The horizontal offset of the cropping mask from the upper-left
          # corner of the image.
          left: 'left',

          # The height of the cropping mask.
          height: 'height',

          # The width of the cropping mask.
          widgth: 'width'
        )
      end
    end
  end
end
