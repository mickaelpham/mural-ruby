# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Areas
        # https://developers.mural.co/public/reference/createarea
        def create_area(mural_id, create_area_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/area",
            create_area_params.encode
          )

          Mural::Widget.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/updatearea
        def update_area(mural_id, area_id, update_area_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/area/#{area_id}",
            update_area_params.encode
          )

          Mural::Widget.decode(json['value'])
        end
      end
    end
  end
end
