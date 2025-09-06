# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Widgets
        # https://developers.mural.co/public/reference/getmuralwidgets
        def list_widgets(mural_id, type: nil, parent_id: nil, next_page: nil)
          json = get(
            "/api/public/v1/murals/#{mural_id}/widgets",
            { type: type, parentId: parent_id, next: next_page }
          )

          widgets = json['value'].map { |w| Mural::Widget.decode(w) }

          [widgets, json['next']]
        end

        # https://developers.mural.co/public/reference/getmuralwidget
        def retrieve_widget(mural_id, widget_id)
          json = get("/api/public/v1/murals/#{mural_id}/widgets/#{widget_id}")

          Mural::Widget.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/deletewidgetbyid
        def destroy_widget(mural_id, widget_id)
          delete("/api/public/v1/murals/#{mural_id}/widgets/#{widget_id}")
        end
      end
    end
  end
end
