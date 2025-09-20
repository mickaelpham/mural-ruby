# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Tables
        # Create a table widget on a mural.
        #
        # Authorization scope: murals:write
        #
        # https://developers.mural.co/public/reference/createtable
        def create_table(mural_id, create_table_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/widgets/table",
            create_table_params.encode
          )

          # We receive a mix of Table and TableCell widgets
          json['value'].map { |widget| Mural::Widget.decode(widget) }
        end
      end
    end
  end
end
