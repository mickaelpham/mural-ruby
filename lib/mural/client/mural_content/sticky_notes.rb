# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module StickyNotes
        # Create one or more sticky note widgets on a mural. Limit 1000.
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/createstickynote
        def create_sticky_notes(mural_id, create_sticky_note_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/sticky-note",
            [*create_sticky_note_params].map(&:encode)
          )

          json['value'].map { |s| Mural::Widget::StickyNote.decode(s) }
        end

        # Update a sticky note widget on a mural.
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/updatestickynote
        def update_sticky_note(
          mural_id, sticky_note_id, update_sticky_note_params
        )
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/sticky-note" \
            "/#{sticky_note_id}",
            update_sticky_note_params.encode
          )

          Mural::Widget::StickyNote.decode(json['value'])
        end
      end
    end
  end
end
