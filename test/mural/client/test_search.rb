# frozen_string_literal: true

require 'test_helper'

class TestSearch < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_murals
    workspace_id = 'workspace-1'
    room_id = 'room-1'
    query = 'foobar'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/search/#{workspace_id}/murals"
    )
      .with(query: { q: query, roomId: room_id })
      .to_return_json(
        body: {
          value: [
            {
              id: 'mural-1',
              roomId: 'room-1',
              workspaceId: workspace_id
            }
          ]
        }
      )

    murals, = @client.search.murals(
      query,
      workspace_id: workspace_id,
      room_id: room_id
    )

    assert_equal 1, murals.size

    mural = murals.first

    assert_instance_of Mural::SearchMuralResult, mural
    assert_equal 'mural-1', mural.id
    assert_equal room_id, mural.room_id
    assert_equal workspace_id, mural.workspace_id
  end

  def test_rooms
    workspace_id = 'workspace-1'
    query = 'zulu'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/search/#{workspace_id}/rooms"
    )
      .with(query: { q: query })
      .to_return_json(
        body: {
          value: [
            {
              id: 'room-2',
              workspaceId: workspace_id
            }
          ]
        }
      )

    rooms, = @client.search.rooms(query, workspace_id: workspace_id)

    assert_equal 1, rooms.size

    room = rooms.first

    assert_instance_of Mural::SearchRoomResult, room
    assert_equal 'room-2', room.id
    assert_equal workspace_id, room.workspace_id
  end

  def test_templates
    workspace_id = 'workspace-1'
    query = 'charlie'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/search/#{workspace_id}/templates"
    )
      .with(query: { q: query })
      .to_return_json(
        body: {
          value: [
            {
              id: 'template-3',
              workspaceId: workspace_id
            }
          ]
        }
      )

    templates, = @client.search.templates(query, workspace_id: workspace_id)

    assert_equal 1, templates.size

    template = templates.first

    assert_instance_of Mural::SearchTemplateResult, template
    assert_equal 'template-3', template.id
    assert_equal workspace_id, template.workspace_id
  end
end
