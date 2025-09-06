# frozen_string_literal: true

module Mural
  class UpdateRoomParams
    include Mural::Codec

    # https://developers.mural.co/public/reference/updateroombyid
    define_attributes(
      description: 'description',
      favorite: 'favorite',
      name: 'name',
      type: 'type'
    )
  end
end
