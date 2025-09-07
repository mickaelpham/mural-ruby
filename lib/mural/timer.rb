# frozen_string_literal: true

module Mural
  class Timer
    include Mural::Codec

    define_attributes(
      # Timer duration in seconds.
      duration: 'duration',
      # The initial timestamp of the timer in ms.
      initial_timestamp: 'initialTimestamp',
      # The current timestamp of the timer in ms.
      now: 'now',
      # The paused timestamp of the timer in ms. Null if no pause action was
      # performed.
      paused_timestamp: 'pausedTimestamp',
      # If true, the timer will play a sound when it ends.
      sound_enabled: 'soundEnabled'
    )
  end
end
