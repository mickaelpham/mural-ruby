# frozen_string_literal: true

module Mural
  class Client
    class Murals
      extend Forwardable

      def_delegators :@client, :get, :post, :patch, :delete

      def initialize(client)
        @client = client
      end

      # https://developers.mural.co/public/reference/getmuralbyid
      def retrieve(mural_id)
        json = get("/api/public/v1/murals/#{mural_id}")

        ::Mural::MuralBoard.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/createmural
      def create(create_params)
        json = post('/api/public/v1/murals', create_params.encode)

        ::Mural::MuralBoard.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/updatemuralbyid
      def update(mural_id, update_params)
        json = patch("/api/public/v1/murals/#{mural_id}", update_params.encode)

        ::Mural::MuralBoard.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/deletemuralbyid
      def destroy(mural_id)
        delete("/api/public/v1/murals/#{mural_id}")
      end

      # https://developers.mural.co/public/reference/exportmural
      def export(mural_id, download_format: 'pdf')
        json = post(
          "/api/public/v1/murals/#{mural_id}/export",
          { downloadFormat: download_format }
        )

        json.dig('value', 'exportId')
      end

      # https://developers.mural.co/public/reference/exporturlmural
      def export_url(mural_id, export_id)
        json = get("/api/public/v1/murals/#{mural_id}/exports/#{export_id}")

        ::Mural::MuralExport.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/duplicatemural
      def duplicate(mural_id, duplicate_params)
        json = post(
          "/api/public/v1/murals/#{mural_id}/duplicate", duplicate_params.encode
        )

        ::Mural::MuralBoard.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/getworkspacemurals
      def for_workspace(workspace_id, status: nil, sort_by: nil, next_page: nil)
        json = get(
          "/api/public/v1/workspaces/#{workspace_id}/murals",
          { status: status, sortBy: sort_by, next: next_page }
        )

        murals = json['value'].map do |json_mural|
          ::Mural::MuralBoard.decode(json_mural)
        end

        [murals, json['next']]
      end

      # https://developers.mural.co/public/reference/getworkspacerecentmurals
      def recently_opened_in_workspace(workspace_id, next_page: nil)
        json = get(
          "/api/public/v1/workspaces/#{workspace_id}/murals/recent",
          { next: next_page }
        )

        murals = json['value'].map do |json_mural|
          ::Mural::MuralBoard.decode(json_mural)
        end

        [murals, json['next']]
      end

      # https://developers.mural.co/public/reference/getroommurals
      def for_room( # rubocop:disable Metrics/MethodLength
        room_id,
        folder_id: nil,
        status: nil,
        sort_by: nil,
        next_page: nil
      )
        json = get(
          "/api/public/v1/rooms/#{room_id}/murals",
          {
            folderId: folder_id,
            status: status,
            sortBy: sort_by,
            next: next_page
          }
        )

        murals = json['value'].map do |json_mural|
          ::Mural::MuralBoard.decode(json_mural)
        end

        [murals, json['next']]
      end

      # https://developers.mural.co/public/reference/muralaccessinfo
      def access_information(mural_id, mural_state:)
        json = post(
          "/api/public/v1/murals/#{mural_id}/access-info",
          { muralState: mural_state }
        )

        ::Mural::MuralBoard::AccessInformation.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/resetvisitorlink
      def reset_visitor_link(mural_id)
        json =
          post("/api/public/v1/murals/#{mural_id}/visitor-settings/reset-link")

        ::Mural::MuralBoard::VisitorsSettings.decode(json['value'])
      end
    end
  end
end
