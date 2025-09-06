# frozen_string_literal: true

module Mural
  class RoomInvitationParams
    include Mural::Codec

    # https://developers.mural.co/public/reference/inviteuserstoroom
    define_attributes(
      email: 'email',
      username: 'username'
    )
  end
end
