# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module TextBoxes
        # Create one or more text box widgets on a mural. Limit 1000.
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/createtextbox
        def create_text_boxes(mural_id, create_text_box_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/textbox",
            [*create_text_box_params].map(&:encode)
          )

          json['value'].map { |text_box| Mural::Widget.decode(text_box) }
        end

        # Update a textbox on a mural
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/updatetextbox
        def update_text_box(mural_id, text_box_id, update_text_box_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/textbox/#{text_box_id}",
            update_text_box_params.encode
          )

          Mural::Widget.decode(json['value'])
        end
      end
    end
  end
end
