# frozen_string_literal: true

module Mural
  class UpdateTimerParams
    include Mural::Codec

    define_attributes(
      # Add +/- extra time to the running timer in seconds.
      delta: 'delta',
      # If true, the timer will pause.
      paused: 'paused',
      # If true, the timer will play a sound when it ends.
      sound_enabled: 'soundEnabled'
    )
  end
end
