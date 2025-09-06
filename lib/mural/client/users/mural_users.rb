# frozen_string_literal: true

module Mural
  class Client
    class Users
      module MuralUsers
        # https://developers.mural.co/public/reference/getmuralusers
        def mural_users(mural_id, next_page: nil)
          json = get(
            "/api/public/v1/murals/#{mural_id}/users",
            { next: next_page }
          )

          users = json['value'].map do |json_user|
            ::Mural::MuralUser.decode(json_user)
          end

          [users, json['next']]
        end

        # https://developers.mural.co/public/reference/updatemuralmemberpermissions
        def update_mural_user_permissions(
          mural_id,
          user_id,
          owner: nil,
          facilitator: nil
        )
          patch(
            "/api/public/v1/murals/#{mural_id}/users/#{user_id}/permissions",
            { owner: owner, facilitator: facilitator }
          )
        end

        # https://developers.mural.co/public/reference/inviteuserstomural
        def invite_mural_users(
          mural_id,
          message: nil,
          invitations: [],
          send_email: false
        )
          json = post(
            "/api/public/v1/murals/#{mural_id}/users/invite",
            {
              message: message,
              invitations: invitations.map(&:encode),
              sendEmail: send_email
            }
          )

          json['value'].map { |result| ::Mural::MuralInvitation.decode(result) }
        end

        # https://developers.mural.co/public/reference/removemuralusers
        def remove_mural_users(mural_id, emails: [])
          json = post(
            "/api/public/v1/murals/#{mural_id}/users/remove",
            { emails: emails }
          )

          json['value'].map do |removed_user|
            Mural::RemovedMuralUser.decode(removed_user)
          end
        end
      end
    end
  end
end
