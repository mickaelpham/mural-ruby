# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module StickyNotes
        # https://developers.mural.co/public/reference/createstickynote
        def create_sticky_notes(mural_id, create_sticky_note_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/sticky-note",
            [*create_sticky_note_params].map(&:encode)
          )

          json['value'].map { |s| Mural::Widget::StickyNote.decode(s) }
        end

        # https://developers.mural.co/public/reference/updatestickynote
        def update_sticky_note(mural_id, widget_id, update_sticky_note_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/sticky-note" \
            "/#{widget_id}",
            update_sticky_note_params.encode
          )

          Mural::Widget::StickyNote.decode(json['value'])
        end
      end
    end
  end
end
