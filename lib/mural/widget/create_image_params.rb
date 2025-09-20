# frozen_string_literal: true

module Mural
  class Widget
    class CreateImageParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/createimage
      define_attributes(
        **Mural::Widget::Image.attrs.filter do |attr|
          %i[
            border
            caption
            description
            height
            hidden
            instruction
            parent_id
            presentation_index
            rotation
            show_caption
            stacking_order
            width
            x
            y
          ].include? attr
        end,

        # The name of the image.
        # The allowed image formats are: bmp, ico, gif, jpeg, jpg, png, webp.
        name: 'name',

        # The URL used in the widget.
        hyperlink: 'hyperlink'
      )
    end
  end
end
