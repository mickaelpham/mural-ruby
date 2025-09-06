# frozen_string_literal: true

module Mural
  class Client
    class Search
      extend Forwardable

      def_delegators :@client, :get

      def initialize(client)
        @client = client
      end

      # https://developers.mural.co/public/reference/searchmurals
      def murals(query, workspace_id:, next_page: nil, room_id: nil)
        json = get(
          "/api/public/v1/search/#{workspace_id}/murals",
          { next: next_page, q: query, roomId: room_id }
        )

        murals = json['value'].map do |hit|
          Mural::SearchMuralResult.decode(hit)
        end

        [murals, json['next']]
      end

      # https://developers.mural.co/public/reference/searchrooms
      def rooms(query, workspace_id:, next_page: nil)
        json = get(
          "/api/public/v1/search/#{workspace_id}/rooms",
          { next: next_page, q: query }
        )

        rooms = json['value'].map { |hit| Mural::SearchRoomResult.decode(hit) }

        [rooms, json['next']]
      end

      # https://developers.mural.co/public/reference/searchtemplates
      def templates(query, workspace_id:, next_page: nil)
        json = get(
          "/api/public/v1/search/#{workspace_id}/templates",
          { next: next_page, q: query }
        )

        templates = json['value'].map do |hit|
          Mural::SearchTemplateResult.decode(hit)
        end

        [templates, json['next']]
      end
    end
  end
end
