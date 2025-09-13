# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Shapes
        # Create one or more shape widgets on a mural. Limit 1000.
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/createshapewidget
        def create_shapes(mural_id, create_shape_params)
          data = [*create_shape_params]
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/shape",
            data.map(&:encode)
          )
          json['value'].map do |json_shape|
            Mural::Widget::Shape.decode(json_shape)
          end
        end

        # Update a shape widget on a mural.
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/updateshapewidget
        def update_shape(mural_id, shape_id, update_shape_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/shape/#{shape_id}",
            update_shape_params.encode
          )

          Mural::Widget::Shape.decode(json['value'])
        end
      end
    end
  end
end
