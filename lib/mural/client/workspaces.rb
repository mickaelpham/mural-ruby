# frozen_string_literal: true

module Mural
  class Client
    class Workspaces
      extend Forwardable

      def_delegators :@client, :get, :post, :patch

      def initialize(client)
        @client = client
      end

      # https://developers.mural.co/public/reference/getworkspaces
      def list(next_page: nil)
        json = get('/api/public/v1/workspaces', { next: next_page })

        workspaces = json['value'].map do |json_wp|
          ::Mural::Workspace.decode(json_wp)
        end

        [workspaces, json['next']]
      end

      # https://developers.mural.co/public/reference/getworkspace
      def retrieve(workspace_id)
        json = get("/api/public/v1/workspaces/#{workspace_id}")

        ::Mural::Workspace.decode(json['value'])
      end
    end
  end
end
