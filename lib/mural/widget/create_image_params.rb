# frozen_string_literal: true

module Mural
  class Widget
    class CreateImageParams
      include Mural::Codec

      define_attributes(
        **Mural::Widget::Image.attrs.reject do |attr|
          %i[
            aspect_ratio
            content_edited_by
            content_edited_on
            created_by
            created_on
            expires_in_minutes
            hide_editor
            hide_owner
            id
            invisible
            link
            locked
            locked_by_facilitator
            mask
            natural_height
            natural_width
            thumbnail_url
            type
            updated_by
            updated_on
            url
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
