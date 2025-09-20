# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Arrows
        # https://developers.mural.co/public/reference/createarrow
        def create_arrow(mural_id, create_arrow_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/arrow",
            create_arrow_params.encode
          )

          Mural::Widget.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/updatearrow
        def update_arrow(mural_id, arrow_id, update_arrow_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/arrow/#{arrow_id}",
            update_arrow_params.encode
          )

          Mural::Widget.decode(json['value'])
        end
      end
    end
  end
end
