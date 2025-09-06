# frozen_string_literal: true

module Mural
  class RoomInvitation
    include Mural::Codec

    # https://developers.mural.co/public/reference/inviteuserstoroom
    define_attributes(
      email: 'email',
      ref_code: 'refCode',
      rejected: 'rejected',
      reason: 'reason',
      username: 'username'
    )
  end
end
