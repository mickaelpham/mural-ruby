# frozen_string_literal: true

module Mural
  module Invader
    class Board
      INVADER = {
        'crab' => 'Mural::Invader::Crab::SPRITE',
        'octopus' => 'Mural::Invader::Octopus::SPRITE',
        'squid' => 'Mural::Invader::Squid::SPRITE'
      }.freeze

      ROWS = [
        ['squid', '#69ED36FF'],
        ['crab', '#69ED36FF'],
        ['crab', '#68F1F4FF'],
        ['octopus', '#68F1F4FF'],
        ['octopus', '#D937EEFF']
      ].freeze
      COLS = 11

      # the widest invader (octopus) is 12 "pixels" wide
      MAX_INVADER_WIDTH = 12

      # they are all the same height
      MAX_INVADER_HEIGHT = 8

      # the gitter scale with the size of the "pixel"
      GUTTER_SIZE = 3

      # how many shapes can we send in a single request
      MAX_SHAPES_IN_PAYLOAD = 1_000

      attr_reader :client, :mural_id

      def initialize(client, mural_id)
        @client = client
        @mural_id = mural_id
      end

      def draw_invader_grid(draw_invader_params) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        draw_invader_params.to_h => { origin:, pixel_width:, variant: }
        origin_x, origin_y = origin

        cell_width = (MAX_INVADER_WIDTH + GUTTER_SIZE) * pixel_width
        cell_height = (MAX_INVADER_HEIGHT + GUTTER_SIZE) * pixel_width

        payload = ROWS.flat_map.with_index do |invader, row|
          invader_kind, invader_color = invader

          (0...COLS).flat_map do |col|
            cell_origin = [
              origin_x + (cell_width * col),
              origin_y + (cell_height * row)
            ]

            cell_invader_params =
              Mural::Invader::DrawInvaderParams.new.tap do |params|
                params.color = invader_color
                params.origin = cell_origin
                params.variant = variant
                params.pixel_width = pixel_width
              end

            invader_shape(invader_kind, cell_invader_params)
          end
        end

        payload.each_slice(MAX_SHAPES_IN_PAYLOAD) do |shapes|
          client.mural_content.create_shapes(mural_id, shapes)
        end
      end

      def draw_invader(kind, draw_invader_params)
        client
          .mural_content
          .create_shapes(mural_id, invader_shape(kind, draw_invader_params))
      end

      def invader_shape( # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        kind,
        draw_invader_params
      )
        draw_invader_params.to_h => { color:, origin:, pixel_width:, variant: }
        sprite = Object.const_get(INVADER[kind])[variant]
        origin_x, origin_y = origin

        sprite.flat_map.with_index do |row_content, row|
          row_content.map.with_index do |cell, col|
            next unless cell == 1

            Mural::Widget::CreateShapeParams.new.tap do |params|
              params.x = origin_x + (col * pixel_width)
              params.y = origin_y + (row * pixel_width)
              params.width = pixel_width
              params.height = pixel_width
              params.shape = 'square'

              params.style =
                Mural::Widget::CreateShapeParams::Style.new.tap do |style|
                  style.background_color = color

                  # We want a transparent border, else the "pixel" is wider than
                  # the desired dimension
                  style.border_color = '#00000000'
                end
            end
          end
        end.compact
      end
    end
  end
end
