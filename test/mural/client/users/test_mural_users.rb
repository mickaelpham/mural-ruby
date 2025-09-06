# frozen_string_literal: true

require 'test_helper'

class TestMuralUsers < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_mural_users_given_no_users
    mural_id = 'my-mural'

    stub_request(
      :get, "https://app.mural.co/api/public/v1/murals/#{mural_id}/users"
    ).to_return_json(
      body: {
        value: [],
        next: nil
      }
    )

    assert_equal [[], nil], @client.users.mural_users(mural_id)
  end

  def test_mural_users_given_one_user
    mural_id = 'my-mural'

    stub_request(
      :get, "https://app.mural.co/api/public/v1/murals/#{mural_id}/users"
    ).to_return_json(
      body: {
        value: [
          {
            id: 'my-user',
            firstName: 'John',
            lastName: 'Doe',
            email: 'john.doe@example.com',
            permissions: { facilitator: true, owner: true }
          }
        ],
        next: nil
      }
    )

    users, = @client.users.mural_users(mural_id)
    my_user = users.first

    assert_equal 'my-user', my_user.id
    assert_equal 'John', my_user.first_name
    assert_equal 'Doe', my_user.last_name
    assert_equal 'john.doe@example.com', my_user.email
    assert my_user.permissions.owner
    assert my_user.permissions.facilitator
  end

  def test_update_mural_user_permissions
    mural_id = 'some-mural'
    user_id = 'some-user'

    uri = "https://app.mural.co/api/public/v1/murals/#{mural_id}/users" \
          "/#{user_id}/permissions"

    stub_request(:patch, uri)
      .with(body: { facilitator: true })
      .to_return_json({})

    @client.users.update_mural_user_permissions(
      mural_id,
      user_id,
      facilitator: true
    )
  end

  def test_invite_mural_users
    mural_id = 'some-mural'

    uri = "https://app.mural.co/api/public/v1/murals/#{mural_id}/users/invite"

    stub_request(:post, uri)
      .with(
        body: {
          message: 'Test message for invitation',
          invitations: [
            {
              editPermission: 'view',
              email: 'view-only-user@example.com'
            }
          ],
          sendEmail: true
        }
      )
      .to_return_json(
        body: {
          value: [
            {
              email: 'view-only-user@example.com',
              refCode: 'some-uuid-1'
            }
          ]
        }
      )

    invitation = @client.users.invite_mural_users(
      mural_id,
      message: 'Test message for invitation',
      invitations: [
        Mural::MuralInvitationParams.new.tap do |params|
          params.edit_permission = 'view'
          params.email = 'view-only-user@example.com'
        end
      ],
      send_email: true
    ).first

    assert_equal 'view-only-user@example.com', invitation.email
    assert_equal 'some-uuid-1', invitation.ref_code
  end

  def test_remove_mural_users
    mural_id = 'mural-5'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/users/remove"
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

    removed_user, rejected_user = @client.users.remove_mural_users(
      mural_id,
      emails: ['user-1@example.com', 'user-2@example.com']
    )

    assert_instance_of Mural::RemovedMuralUser, removed_user
    assert_equal 'user-1@example.com', removed_user.email

    assert_instance_of Mural::RemovedMuralUser, rejected_user
    assert_equal 'user-2@example.com', rejected_user.email
    assert rejected_user.rejected
    assert_equal 'some reason', rejected_user.reason
  end
end
