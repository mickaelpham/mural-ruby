# frozen_string_literal: true

module Mural
  class VotingSession
    include Mural::Codec

    # https://developers.mural.co/public/reference/getmuralvotingsessions
    define_attributes(
      # The ID of the voting session.
      id: 'id',
      # The title of the voting session.
      title: 'title'
    )
  end
end
