# frozen_string_literal: true

module Mural
  class Client
    class Users
      extend Forwardable

      include Users::MuralUsers
      include Users::RoomUsers

      def_delegators :@client, :get, :post, :patch

      def initialize(client)
        @client = client
      end

      # https://developers.mural.co/public/reference/getcurrentmember
      def current_user
        json = get('/api/public/v1/users/me')['value']

        ::Mural::CurrentUser.decode(json)
      end

      # https://developers.mural.co/public/reference/inviteuserstoworkspace
      def invite_workspace_users(workspace_id, message: nil, emails: [])
        json = post(
          "/api/public/v1/workspaces/#{workspace_id}/users/invite",
          {
            message: message,
            invitations: emails.map { |email| { email: email } }
          }
        )

        json['value'].map { |inv| Mural::WorkspaceInvitation.decode(inv) }
      end
    end
  end
end
