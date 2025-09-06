# frozen_string_literal: true

require 'test_helper'

class TestTemplates < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_default_templates
    template_json = {
      id: 'template-1',
      description: 'some description',
      createdOn: 1,
      createdBy: 'user-1',
      updatedOn: 1,
      updatedBy: 'user-1',
      workspaceId: 'workspace-1',
      thumbUrl: 'thumb-url',
      viewLink: 'view-link'
    }

    stub_request(:get, 'https://app.mural.co/api/public/v1/templates')
      .to_return_json(body: { value: [template_json] })

    templates, = @client.templates.default_templates
    template = templates.first

    assert_instance_of Mural::Template, template
    assert_equal 'template-1', template.id
    assert_equal 'some description', template.description
    assert_equal 1, template.created_on
    assert_equal 'user-1', template.created_by
    assert_equal 1, template.updated_on
    assert_equal 'user-1', template.updated_by
    assert_equal 'workspace-1', template.workspace_id
    assert_equal 'thumb-url', template.thumb_url
    assert_equal 'view-link', template.view_link
  end

  def test_create_custom
    mural_id = 'mural-1'
    description = 'another description'
    title = 'my title'

    stub_request(:post, 'https://app.mural.co/api/public/v1/templates')
      .with(body: { title: title, muralId: mural_id, description: description })
      .to_return_json(
        body: {
          value: {
            id: 'template-1',
            muralId: mural_id,
            name: title,
            description: description
          }
        },
        status: 201
      )

    template = @client.templates.create_custom(
      mural_id: mural_id,
      description: description,
      title: title
    )

    assert_instance_of Mural::Template, template
    assert_equal 'template-1', template.id
    assert_equal mural_id, template.mural_id
    assert_equal description, template.description
  end

  def test_destroy
    template_id = 'template-1'

    delete_request = stub_request(
      :delete,
      "https://app.mural.co/api/public/v1/templates/#{template_id}"
    ).to_return(status: 204)

    @client.templates.destroy(template_id)

    assert_requested delete_request
  end

  def test_create_mural
    template_id = 'template-3'
    title = 'Mural title'
    room_id = 1
    folder_id = 'folder-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/templates/#{template_id}/murals"
    )
      .with(body: { title: title, roomId: room_id, folderId: folder_id })
      .to_return_json(
        body: {
          value: {
            id: 'mural-1',
            roomId: room_id,
            folderId: folder_id,
            title: title
          }
        },
        status: 201
      )

    mural = @client.templates.create_mural(
      template_id,
      title: title,
      room_id: room_id,
      folder_id: folder_id
    )

    assert_instance_of Mural::MuralBoard, mural
    assert_equal 'mural-1', mural.id
    assert_equal title, mural.title
    assert_equal room_id, mural.room_id
    assert_equal folder_id, mural.folder_id
  end

  def test_for_workspace
    workspace_id = 'workspace-1'

    template_json = {
      id: 'template-1',
      workspaceId: workspace_id,
      muralId: 'mural-1',
      type: 'custom'
    }

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/workspaces/#{workspace_id}/templates"
    )
      .with(query: { withoutDefault: false })
      .to_return_json(body: { value: [template_json] })

    templates, = @client.templates.for_workspace(
      workspace_id,
      without_default: false
    )

    template = templates.first

    assert_instance_of Mural::Template, template
    assert_equal 'template-1', template.id
    assert_equal 'mural-1', template.mural_id
    assert_equal 'custom', template.type
    assert_equal workspace_id, template.workspace_id
  end

  def test_recent_for_workspace
    workspace_id = 'workspace-1'

    template_json = {
      id: 'template-1',
      workspaceId: workspace_id,
      muralId: 'mural-1',
      type: 'custom'
    }

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/workspaces/#{workspace_id}" \
      '/templates/recent'
    )
      .with(query: { withoutDefault: false })
      .to_return_json(body: { value: [template_json] })

    templates, = @client.templates.recent_for_workspace(
      workspace_id,
      without_default: false
    )

    template = templates.first

    assert_instance_of Mural::Template, template
    assert_equal 'template-1', template.id
    assert_equal 'mural-1', template.mural_id
    assert_equal 'custom', template.type
    assert_equal workspace_id, template.workspace_id
  end
end
