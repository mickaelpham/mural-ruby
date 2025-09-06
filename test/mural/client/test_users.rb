# frozen_string_literal: true

require 'test_helper'

class TestUsers < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_current_user
    stub_request(:get, 'https://app.mural.co/api/public/v1/users/me')
      .to_return_json(
        body: {
          value: {
            id: 'my-user-123',
            email: 'john.doe@sample.com',
            firstName: 'John',
            lastName: 'Doe',
            createdOn: 123,
            lastActiveWorkspace: 'yourcoolworkspace1234'
          }
        }
      )

    current_user = @client.users.current_user

    assert_equal 'my-user-123', current_user.id
    assert_equal 'John', current_user.first_name
    assert_equal 'Doe', current_user.last_name
    assert_equal 123, current_user.created_on
    assert_equal 'john.doe@sample.com', current_user.email
    assert_equal 'yourcoolworkspace1234', current_user.last_active_workspace
  end

  def test_invite_workspace_users
    workspace_id = 'some-workspace-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/workspaces/#{workspace_id}" \
      '/users/invite'
    )
      .with(body: {})
      .to_return_json(
        body: {
          value: [
            { email: 'user-1@example.com', refCode: 'some-ref-code-1' }
          ]
        },
        status: 201
      )

    invitations = @client.users.invite_workspace_users(
      workspace_id,
      message: 'Some message',
      emails: ['user-1@example.com']
    )

    assert_equal 'some-ref-code-1', invitations.first.ref_code
  end
end
