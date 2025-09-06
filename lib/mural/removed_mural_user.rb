# frozen_string_literal: true

module Mural
  class RemovedMuralUser
    include Mural::Codec

    # https://developers.mural.co/public/reference/removemuralusers
    define_attributes(
      email: 'email',
      rejected: 'rejected',
      reason: 'reason'
    )
  end
end
