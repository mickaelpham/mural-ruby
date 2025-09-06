# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Tags
        # https://developers.mural.co/public/reference/getmuraltags
        def list_tags(mural_id)
          json = get("/api/public/v1/murals/#{mural_id}/tags")

          json['value'].map { |tag| Mural::Tag.decode(tag) }
        end

        # https://developers.mural.co/public/reference/gettagbyid
        def retrieve_tag(mural_id, tag_id)
          json = get("/api/public/v1/murals/#{mural_id}/tags/#{tag_id}")

          Mural::Tag.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/createmuraltag
        def create_tag(mural_id, create_tag_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/tags",
            create_tag_params.encode
          )

          Mural::Tag.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/updatetagbyid
        def update_tag(mural_id, tag_id, update_tag_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/tags/#{tag_id}",
            update_tag_params.encode
          )

          Mural::Tag.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/deletetagbyid
        def destroy_tag(mural_id, tag_id)
          delete("/api/public/v1/murals/#{mural_id}/tags/#{tag_id}")
        end
      end
    end
  end
end
