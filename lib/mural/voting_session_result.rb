# frozen_string_literal: true

module Mural
  class VotingSessionResult
    include Mural::Codec

    define_attributes(
      # Unique identifier of a widget.
      widget_id: 'widgetId',
      # The total number of votes for the widget.
      total_votes: 'totalVotes',
      # The number of unique collaborators that voted for the widget.
      uniqueVoters: 'uniqueVoters'
    )
  end
end
