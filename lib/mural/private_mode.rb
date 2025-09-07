# frozen_string_literal: true

module Mural
  class PrivateMode
    include Mural::Codec

    # https://developers.mural.co/public/reference/startprivatemode
    define_attributes(
      # If true, the private mode is active.
      active: 'active',
      # The timestamp when private mode started.
      initial_timestamp: 'initialTimestamp',
      # The user who started the private mode.
      started_by: 'startedBy',
      # If true, the authors of the content will be hidden.
      hide_authors: 'hideAuthors'
    )
  end
end
