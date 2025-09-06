# frozen_string_literal: true

module Mural
  class UpdateRoomUserParams
    include Mural::Codec

    define_attributes(
      create_murals: 'createMurals',
      duplicate_room: 'duplicateRoom',
      invite_others: 'inviteOthers',
      owner: 'owner',
      username: 'username',
      ref_code: 'refCode'
    )
  end
end
