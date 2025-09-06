# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Files
        # https://developers.mural.co/public/reference/createfile
        def create_file(mural_id, params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/file",
            params.encode
          )

          Mural::Widget::File.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/getmuralfilewidgets
        def list_files(mural_id, next_page: nil)
          json = get(
            "/api/public/v1/murals/#{mural_id}/widgets/files",
            { next: next_page }
          )

          files = json['value'].map { |f| Mural::Widget::File.decode(f) }
          [files, json['next']]
        end

        # https://developers.mural.co/public/reference/updatefile
        def update_file(mural_id, widget_id:, update_file_params:)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/widgets/file/#{widget_id}",
            update_file_params.encode
          )

          Mural::Widget::File.decode(json['value'])
        end
      end
    end
  end
end
