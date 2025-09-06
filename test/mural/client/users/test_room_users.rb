# frozen_string_literal: true

require 'test_helper'

class TestRoomUsers < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_room_users_given_no_users
    room_id = 'some-room'

    stub_request(
      :get, "https://app.mural.co/api/public/v1/rooms/#{room_id}/users"
    ).to_return_json(
      body: {
        value: [],
        next: nil
      }
    )

    assert_equal [[], nil], @client.users.room_users(room_id)
  end

  def test_room_users_given_one_user
    room_id = 'some-room'

    stub_request(
      :get, "https://app.mural.co/api/public/v1/rooms/#{room_id}/users"
    ).to_return_json(
      body: {
        value: [
          {
            id: 'some-user',
            email: 'jane.doe@example.com',
            firstName: 'Jane',
            lastName: 'Doe',
            type: 'member'
          }
        ],
        next: nil
      }
    )

    users, = @client.users.room_users(room_id)
    u = users.first

    assert_equal 'some-user', u.id
    assert_equal 'jane.doe@example.com', u.email
    assert_equal 'Jane', u.first_name
    assert_equal 'Doe', u.last_name
    assert_equal 'member', u.type
  end

  def test_update_room_user_permissions
    room_id = 'room-2'
    room_users = [
      Mural::UpdateRoomUserParams.new.tap do |user|
        user.create_murals = true
        user.duplicate_room = true
        user.invite_others = true
        user.owner = true
        user.username = 'some-user-1'
      end
    ]

    update_request = stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/rooms/#{room_id}/users/permissions"
    ).with(
      body: {
        members: [
          {
            createMurals: true,
            duplicateRoom: true,
            inviteOthers: true,
            owner: true,
            username: 'some-user-1'
          }
        ]
      }
    ).to_return_json(body: {}, status: 200)

    @client.users.update_room_user_permissions(room_id, room_users: room_users)

    assert_requested update_request
  end

  def test_invite_room_users
    room_id = 'room-9'
    message = 'Join this room'
    send_email = true
    email = 'user@example.com'

    params = Mural::RoomInvitationParams.new.tap do |params|
      params.email = email
    end

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/rooms/#{room_id}/users/invite"
    )
      .with(
        body: {
          message: message,
          invitations: [{ email: email }],
          sendEmail: send_email
        }
      )
      .to_return_json(
        body: { value: [{ email: email, refCode: 'some-uuid-1' }] },
        status: 201
      )

    result = @client.users.invite_room_users(
      room_id,
      message: message,
      room_invitations: [params],
      send_email: send_email
    )

    assert_equal 1, result.size

    invitation = result.first

    assert_instance_of Mural::RoomInvitation, invitation
    assert_equal 'some-uuid-1', invitation.ref_code
    assert_equal email, invitation.email
  end

  def test_remove_room_users
    room_id = 'room-5'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/rooms/#{room_id}/users/remove"
    )
      .with(body: { emails: ['user-1@example.com', 'user-2@example.com'] })
      .to_return_json(
        body: {
          value: [
            {
              email: 'user-1@example.com'
            },
            {
              email: 'user-2@example.com',
              rejected: true,
              reason: 'some reason'
            }
          ]
        }
      )

    removed_user, rejected_user = @client.users.remove_room_users(
      room_id,
      emails: ['user-1@example.com', 'user-2@example.com']
    )

    assert_instance_of Mural::RemovedRoomUser, removed_user
    assert_equal 'user-1@example.com', removed_user.email

    assert_instance_of Mural::RemovedRoomUser, rejected_user
    assert_equal 'user-2@example.com', rejected_user.email
    assert rejected_user.rejected
    assert_equal 'some reason', rejected_user.reason
  end
end
