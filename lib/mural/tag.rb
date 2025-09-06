# frozen_string_literal: true

module Mural
  class Tag
    include Mural::Codec

    # https://developers.mural.co/public/reference/getmuraltags
    define_attributes(
      # The ID of the tag.
      id: 'id',

      # The text in the tag.
      text: 'text',

      # The background color of the tag in hex with alpha format.
      background_color: 'backgroundColor',

      # The border color of the tag in hex with alpha format.
      border_color: 'borderColor',

      # The text color of the tag in hex with alpha format.
      color: 'color'
    )
  end
end
