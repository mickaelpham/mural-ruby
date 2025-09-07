# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module Chats
        # https://developers.mural.co/public/reference/getmuralchat
        def list_chats(mural_id, next_page: nil)
          json = get(
            "/api/public/v1/murals/#{mural_id}/chat",
            { next: next_page }
          )

          chats = json['value'].map { |c| Mural::Chat.decode(c) }
          [chats, json['next']]
        end
      end
    end
  end
end
