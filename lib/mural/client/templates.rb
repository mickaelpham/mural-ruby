# frozen_string_literal: true

module Mural
  class Client
    class Templates
      extend Forwardable

      def_delegators :@client, :get, :post, :delete

      def initialize(client)
        @client = client
      end

      # https://developers.mural.co/public/reference/getdefaulttemplates
      def default_templates(next_page: nil)
        json = get('/api/public/v1/templates', { next: next_page })

        templates = json['value'].map { |tpl| Mural::Template.decode(tpl) }

        [templates, json['next']]
      end

      # https://developers.mural.co/public/reference/createcustomtemplate
      def create_custom(title:, mural_id:, description: nil)
        json = post(
          '/api/public/v1/templates',
          { title: title, muralId: mural_id, description: description }
        )

        Mural::Template.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/deletetemplatebyid
      def destroy(template_id)
        delete("/api/public/v1/templates/#{template_id}")
      end

      # https://developers.mural.co/public/reference/createmuralfromtemplate
      def create_mural(template_id, title:, room_id:, folder_id: nil)
        json = post(
          "/api/public/v1/templates/#{template_id}/murals",
          { title: title, roomId: room_id, folderId: folder_id }
        )

        Mural::MuralBoard.decode(json['value'])
      end

      # https://developers.mural.co/public/reference/gettemplatesbyworkspace
      def for_workspace(workspace_id, next_page: nil, without_default: true)
        json = get(
          "/api/public/v1/workspaces/#{workspace_id}/templates",
          { next: next_page, withoutDefault: without_default }
        )

        templates = json['value'].map { |tpl| Mural::Template.decode(tpl) }

        [templates, json['next']]
      end

      # https://developers.mural.co/public/reference/getrecenttemplates
      def recent_for_workspace(
        workspace_id,
        next_page: nil,
        without_default: true
      )
        json = get(
          "/api/public/v1/workspaces/#{workspace_id}/templates/recent",
          { next: next_page, withoutDefault: without_default }
        )

        templates = json['value'].map { |tpl| Mural::Template.decode(tpl) }

        [templates, json['next']]
      end
    end
  end
end
