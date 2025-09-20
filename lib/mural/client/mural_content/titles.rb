# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Titles
        # Create one or more title widgets on a mural. Limit 1000.
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/createtitle
        def create_titles(mural_id, create_title_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/title",
            [*create_title_params].map(&:encode)
          )

          json['value'].map { |title| Mural::Widget::Text.decode(title) }
        end

        # Update a title on a mural
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/updatetitle
        def update_title(mural_id, title_id, update_title_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/title/#{title_id}",
            update_title_params.encode
          )

          Mural::Widget::Text.decode(json['value'])
        end
      end
    end
  end
end
