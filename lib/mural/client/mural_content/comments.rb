# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Comments
        # Create a comment widget on a mural.
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/createcomment
        def create_comment(mural_id, create_comment_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/comment",
            create_comment_params.encode
          )

          Mural::Widget::Comment.decode(json['value'])
        end

        # Update a comment widget on a mural.
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/updatecomment
        def update_comment(mural_id, comment_id, update_comment_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/comment/#{comment_id}",
            update_comment_params.encode
          )

          Mural::Widget::Comment.decode(json['value'])
        end
      end
    end
  end
end
