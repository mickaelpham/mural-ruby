# frozen_string_literal: true

module Mural
  class StartVotingSessionParams
    include Mural::Codec

    # https://developers.mural.co/public/reference/startmuralvotingsession
    define_attributes(
      # The title of the voting session.
      title: 'title',
      # The number of votes allowed in the session.
      number_of_votes: 'numberOfVotes',
      # The types of widgets that can be voted on in this session.
      widget_types: 'widgetTypes',
      # If true, anyone can end the voting session.
      anyone_can_end: 'anyoneCanEnd',
      # The area on the mural where the voting session will take place.
      area: 'area'
    )

    def encode
      super.tap do |json|
        json['area'] = json['area']&.encode
      end
    end

    class Area
      include Mural::Codec

      define_attributes(
        # The top coordinate of the area.
        top: 'top',
        # The left coordinate of the area.
        left: 'left',
        # The width of the area.
        width: 'width',
        # The height of the area.
        height: 'height'
      )
    end
  end
end
