# frozen_string_literal: true

require 'test_helper'

class TestWorkspaces < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_retrieve
    workspace_id = 'some-workspace-1'

    stub_request(:get, "https://app.mural.co/api/public/v1/workspaces/#{workspace_id}")
      .to_return_json(
        body: {
          value: {
            id: workspace_id,
            name: 'My workspace',
            description: 'A short sentence',
            sharingSettings: { link: 'https://foobar.com/share' },
            locked: false,
            suspended: false,
            createdOn: 1,
            createdBy: {
              id: 'some-user-1',
              firstName: 'Troy',
              lastName: 'Miele'
            }
          }
        }
      )

    workspace = @client.workspaces.retrieve(workspace_id)

    assert_equal workspace_id, workspace.id
    assert_equal 'My workspace', workspace.name
    assert_equal 'A short sentence', workspace.description
    assert_equal 'https://foobar.com/share', workspace.sharing_settings.link
    refute workspace.locked
    refute workspace.suspended
    assert_equal 1, workspace.created_on

    created_by = workspace.created_by

    assert_equal 'some-user-1', created_by.id
    assert_equal 'Troy', created_by.first_name
    assert_equal 'Miele', created_by.last_name
  end

  def test_list
    stub_request(:get, 'https://app.mural.co/api/public/v1/workspaces')
      .to_return_json(
        body: {
          value: [{
            id: 'some-workspace-2',
            name: 'My 2nd workspace',
            description: 'Workspace description',
            locked: true,
            suspended: true,
            createdOn: 2
          }]
        }
      )

    workspaces, = @client.workspaces.list
    workspace = workspaces.first

    assert_equal 'some-workspace-2', workspace.id
    assert_equal 'My 2nd workspace', workspace.name
    assert_equal 'Workspace description', workspace.description
    assert_nil workspace.sharing_settings
    assert workspace.locked
    assert workspace.suspended
    assert_equal 2, workspace.created_on

    # Created by is not available when retrieving a list of workspaces
    assert_nil workspace.created_by
  end
end
