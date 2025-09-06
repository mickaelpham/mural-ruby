# frozen_string_literal: true

module Mural
  class UpdateTagParams
    include Mural::Codec

    # https://developers.mural.co/public/reference/updatetagbyid
    define_attributes(
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
