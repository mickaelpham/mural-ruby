# frozen_string_literal: true

module Mural
  class RemovedRoomUser
    include Mural::Codec

    # https://developers.mural.co/public/reference/removeroomusers
    define_attributes(
      email: 'email',
      rejected: 'rejected',
      reason: 'reason'
    )
  end
end
