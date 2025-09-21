# frozen_string_literal: true

module Mural
  module Invader
    class DrawInvaderParams
      attr_accessor :pixel_width, :color, :origin, :variant

      def initialize
        @pixel_width = 10
        @color = '#000000FF'
        @origin = [0, 0]
        @variant = 0
      end

      def to_h
        {
          pixel_width: pixel_width,
          color: color,
          origin: origin,
          variant: variant
        }
      end
    end
  end
end
