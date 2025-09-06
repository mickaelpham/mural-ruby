# frozen_string_literal: true

module Mural
  class RoomUser
    include Mural::Codec

    # https://developers.mural.co/public/reference/getroommembers
    define_attributes(
      id: 'id',
      email: 'email',
      avatar: 'avatar',
      first_name: 'firstName',
      last_name: 'lastName',
      type: 'type'
    )
  end
end
