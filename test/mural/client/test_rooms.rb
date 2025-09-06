# frozen_string_literal: true

require 'test_helper'

class TestRooms < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create
    name = 'Test Room'
    workspace_id = 'workspace-2'

    stub_request(:post, 'https://app.mural.co/api/public/v1/rooms')
      .with(body: { name: name, workspaceId: workspace_id, type: 'open' })
      .to_return_json(
        body: {
          value: {
            id: 'room-3',
            name: name,
            workspaceId: workspace_id,
            type: 'open'
          }
        },
        status: 201
      )

    room = @client.rooms.create(
      Mural::CreateRoomParams.new.tap do |params|
        params.name = name
        params.type = 'open'
        params.workspace_id = workspace_id
      end
    )

    assert_instance_of Mural::Room, room
    assert_equal 'room-3', room.id
    assert_equal name, room.name
    assert_equal 'open', room.type
    assert_equal workspace_id, room.workspace_id
  end

  def test_update
    room_id = 'room-4'

    stub_request(:patch, "https://app.mural.co/api/public/v1/rooms/#{room_id}")
      .with(body: { name: 'Cool' })
      .to_return_json({ body: { value: { id: room_id, name: 'Cool' } } })

    room = @client.rooms.update(
      room_id,
      Mural::UpdateRoomParams.new.tap { |params| params.name = 'Cool' }
    )

    assert_instance_of Mural::Room, room
    assert_equal 'Cool', room.name
    assert_equal room_id, room.id
  end

  def test_destroy
    room_id = 2

    delete_request = stub_request(
      :delete,
      "https://app.mural.co/api/public/v1/rooms/#{room_id}"
    ).to_return(status: 204)

    @client.rooms.destroy(room_id)

    assert_requested delete_request
  end

  def test_create_folder
    room_id = 'some-room-1'
    name = 'My folder'
    parent_id = 'parent-folder-2'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/rooms/#{room_id}/folders"
    )
      .with(body: { name: name, parentId: parent_id })
      .to_return_json(
        body: { value: { id: 'created-folder-3', name: name } },
        status: 201
      )

    folder = @client.rooms.create_folder(
      room_id,
      name: name,
      parent_id: parent_id
    )

    assert_nil folder.children
    assert_equal 'created-folder-3', folder.id
    assert_equal name, folder.name
  end

  def test_list_folders
    room_id = 'some-room-2'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/rooms/#{room_id}/folders"
    ).to_return_json(
      body: {
        value: [
          {
            id: 'folder-1',
            name: 'Parent',
            children: [
              {
                id: 'folder-1-1',
                name: 'Child 1',
                children: [
                  { id: 'folder-1-1-1', name: 'Sub-child 1' },
                  { id: 'folder-1-1-2', name: 'Sub-child 2' }
                ]
              },
              {
                id: 'folder-1-2',
                name: 'Child 2'
              }
            ]
          }
        ]
      }
    )

    folders, = @client.rooms.list_folders(room_id)

    parent = folders.first

    assert_equal 'folder-1', parent.id
    assert_equal 'Parent', parent.name

    child1 = parent.children[0]

    assert_equal 'folder-1-1', child1.id
    assert_equal 'Child 1', child1.name

    subchild1 = child1.children[0]

    assert_equal 'folder-1-1-1', subchild1.id
    assert_equal 'Sub-child 1', subchild1.name
    assert_nil subchild1.children

    subchild2 = child1.children[1]

    assert_equal 'folder-1-1-2', subchild2.id
    assert_equal 'Sub-child 2', subchild2.name
    assert_nil subchild2.children

    child2 = parent.children[1]

    assert_equal 'folder-1-2', child2.id
    assert_equal 'Child 2', child2.name
    assert_nil child2.children
  end

  def test_destroy_folder
    room_id = 'room-1'
    folder_id = 'folder-2'

    delete_request = stub_request(
      :delete,
      "https://app.mural.co/api/public/v1/rooms/#{room_id}/folders/#{folder_id}"
    ).to_return(status: 204)

    @client.rooms.destroy_folder(room_id, folder_id)

    assert_requested delete_request
  end

  def test_retrieve
    room_id = 'some-room-1'

    stub_request(:get, "https://app.mural.co/api/public/v1/rooms/#{room_id}")
      .to_return_json(
        body: {
          value: {
            id: room_id,
            name: 'My room',
            description: 'Room description',
            favorite: true,
            createdBy: {
              firstName: 'Joe',
              lastName: 'Dalton',
              id: 'some-user-1'
            },
            createdOn: 1,
            updatedBy: {
              firstName: 'Lucky',
              lastName: 'Luke',
              id: 'some-user-2'
            },
            updatedOn: 2,
            type: 'private',
            confidential: false,
            workspaceId: 'some-workspace-1',
            sharingSettings: { link: 'https://example.com/room' }
          }
        }
      )

    room = @client.rooms.retrieve(room_id)

    assert_instance_of(Mural::Room, room)
    assert_equal room_id, room.id
    assert_equal 'My room', room.name
    assert_equal 'Room description', room.description
    assert room.favorite
    assert_equal 1, room.created_on
    assert_equal 2, room.updated_on
    assert_equal 'private', room.type
    refute room.confidential
    assert_equal 'some-workspace-1', room.workspace_id
    assert_equal 'https://example.com/room', room.sharing_settings.link

    created_by = room.created_by

    assert_equal 'Joe', created_by.first_name
    assert_equal 'Dalton', created_by.last_name
    assert_equal 'some-user-1', created_by.id

    updated_by = room.updated_by

    assert_equal 'Lucky', updated_by.first_name
    assert_equal 'Luke', updated_by.last_name
    assert_equal 'some-user-2', updated_by.id
  end

  def test_list
    workspace_id = 'some-workspace-2'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/workspaces/#{workspace_id}/rooms"
    ).to_return_json(
      body: {
        value: [{ id: 'some-room-2' }]
      }
    )

    rooms, = @client.rooms.list(workspace_id)

    assert_equal 1, rooms.size
    assert_equal 'some-room-2', rooms.first.id
  end

  def test_list_open
    workspace_id = 'some-workspace-2'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/workspaces/#{workspace_id}/rooms/open"
    ).to_return_json(
      body: {
        value: [{ id: 'some-room-3' }]
      }
    )

    rooms, = @client.rooms.list_open(workspace_id)

    assert_equal 1, rooms.size
    assert_equal 'some-room-3', rooms.first.id
  end
end
