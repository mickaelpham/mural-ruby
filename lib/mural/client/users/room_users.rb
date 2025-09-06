# frozen_string_literal: true

module Mural
  class Client
    class Users
      module RoomUsers
        # https://developers.mural.co/public/reference/getroommembers
        def room_users(room_id, next_page: nil)
          json = get(
            "/api/public/v1/rooms/#{room_id}/users",
            { next: next_page }
          )

          users = json['value'].map do |json_user|
            ::Mural::RoomUser.decode(json_user)
          end

          [users, json['next']]
        end

        # https://developers.mural.co/public/reference/updateroommemberpermissions
        def update_room_user_permissions(room_id, room_users: [])
          patch(
            "/api/public/v1/rooms/#{room_id}/users/permissions",
            { members: room_users.map(&:encode) }
          )
        end

        # https://developers.mural.co/public/reference/inviteuserstoroom
        def invite_room_users(
          room_id,
          message: nil,
          room_invitations: [],
          send_email: false
        )
          json = post(
            "/api/public/v1/rooms/#{room_id}/users/invite",
            {
              message: message,
              invitations: room_invitations.map(&:encode),
              sendEmail: send_email
            }
          )

          json['value'].map { |result| Mural::RoomInvitation.decode(result) }
        end
      end

      # https://developers.mural.co/public/reference/removeroomusers
      def remove_room_users(room_id, emails: [])
        json = post(
          "/api/public/v1/rooms/#{room_id}/users/remove",
          { emails: emails }
        )

        json['value'].map do |removed_user|
          Mural::RemovedRoomUser.decode(removed_user)
        end
      end
    end
  end
end
