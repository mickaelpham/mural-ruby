# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Images
        # https://developers.mural.co/public/reference/createimage
        def create_image(mural_id, create_image_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/image",
            create_image_params.encode
          )

          Mural::Widget::Image.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/createimage
        def update_image(mural_id, image_id, update_image_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/image/#{image_id}",
            update_image_params.encode
          )

          Mural::Widget::Image.decode(json['value'])
        end
      end
    end
  end
end
