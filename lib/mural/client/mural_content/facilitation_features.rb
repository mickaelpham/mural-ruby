# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module FacilitationFeatures
        # https://developers.mural.co/public/reference/startprivatemode
        def start_private_mode(mural_id, hide_authors: false)
          json = post(
            "/api/public/v1/murals/#{mural_id}/private-mode/start",
            { hideAuthors: hide_authors }
          )

          Mural::PrivateMode.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/stopprivatemode
        def stop_private_mode(mural_id)
          post("/api/public/v1/murals/#{mural_id}/private-mode/stop")
        end

        # https://developers.mural.co/public/reference/getprivatemode
        def retrieve_private_mode(mural_id)
          json = get("/api/public/v1/murals/#{mural_id}/private-mode")

          Mural::PrivateMode.decode(json['value'])
        end
      end
    end
  end
end
