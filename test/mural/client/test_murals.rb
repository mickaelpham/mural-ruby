# frozen_string_literal: true

require 'test_helper'

class TestMurals < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_retrieve
    mural_id = 'some-mural-234'

    stub_request(:get, "https://app.mural.co/api/public/v1/murals/#{mural_id}")
      .to_return_json(
        body: {
          value: {
            backgroundColor: '#FAFAFAFF',
            createdBy: {
              firstName: 'Luke',
              lastName: 'Skywalker',
              id: 'some-user-123'
            },
            createdOn: 123,
            id: mural_id,
            sharingSettings: { link: 'https://example.com' },
            updatedBy: {
              firstName: 'Lana',
              lastName: 'Fitzgerald',
              id: 'another-user-234'
            },
            updatedOn: 234,
            visitorsSettings: {
              link: 'https://foobar.com',
              visitors: 'none',
              workspaceMembers: 'write'
            }
          }
        }
      )

    mural = @client.murals.retrieve(mural_id)

    assert_equal mural_id, mural.id
    assert_equal '#FAFAFAFF', mural.background_color
    assert_equal 123, mural.created_on
    assert_equal 234, mural.updated_on

    created_by = mural.created_by

    assert_equal 'Luke', created_by.first_name
    assert_equal 'Skywalker', created_by.last_name
    assert_equal 'some-user-123', created_by.id

    updated_by = mural.updated_by

    assert_equal 'Lana', updated_by.first_name
    assert_equal 'Fitzgerald', updated_by.last_name
    assert_equal 'another-user-234', updated_by.id

    assert_equal 'https://example.com', mural.sharing_settings.link

    visitors_settings = mural.visitors_settings

    assert_equal 'https://foobar.com', visitors_settings.link
    assert_equal 'none', visitors_settings.visitors
    assert_equal 'write', visitors_settings.workspace_members
  end

  def test_retrieve_with_missing_created_by
    mural_id = 'some-mural-234'

    stub_request(:get, "https://app.mural.co/api/public/v1/murals/#{mural_id}")
      .to_return_json(
        body: {
          value: {
            backgroundColor: '#FAFAFAFF',
            createdOn: 123,
            id: mural_id,
            updatedOn: 234
          }
        }
      )

    mural = @client.murals.retrieve(mural_id)

    assert_equal mural_id, mural.id

    assert_nil mural.created_by
    assert_nil mural.sharing_settings
    assert_nil mural.updated_by
    assert_nil mural.visitors_settings
  end

  def test_export
    mural_id = 'some-mural'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/export"
    )
      .with(body: { downloadFormat: 'pdf' })
      .to_return_json(body: { value: { exportId: 'some-export-0001' } })

    export_id = @client.murals.export(mural_id)

    assert_equal 'some-export-0001', export_id
  end

  def test_export_url
    mural_id = 'some-mural-1'
    export_id = 'some-export-2'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/exports/#{export_id}"
    ).to_return_json(
      body: {
        value: {
          createdOn: 123,
          expireOn: 234,
          exportId: export_id,
          muralId: mural_id,
          url: 'https://foobar.com/download'
        }
      }
    )

    export = @client.murals.export_url(mural_id, export_id)

    assert_equal 123, export.created_on
    assert_equal 234, export.expire_on
    assert_equal export_id, export.export_id
    assert_equal mural_id, export.mural_id
    assert_equal 'https://foobar.com/download', export.url
  end

  def test_for_workspace
    workspace_id = 'some-workspace-1'
    status = 'archived'
    sort_by = 'oldest'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/workspaces/#{workspace_id}/murals"
    )
      .with(query: { status: status, sortBy: sort_by })
      .to_return_json(body: { value: [{ id: 'some-mural-1' }] })

    murals, = @client.murals.for_workspace(
      workspace_id,
      status: status,
      sort_by: sort_by
    )

    assert_equal 'some-mural-1', murals.first.id
  end

  def test_recently_opened_in_workspace
    workspace_id = 'some-workspace-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/workspaces/#{workspace_id}" \
      '/murals/recent'
    ).to_return_json(body: { value: [{ id: 'some-mural-2' }] })

    murals, = @client.murals.recently_opened_in_workspace(workspace_id)

    assert_equal 'some-mural-2', murals.first.id
  end

  def test_for_room
    room_id = 'some-room-1'
    folder_id = 'some-folder-1'
    status = 'archived'
    sort_by = 'oldest'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/rooms/#{room_id}/murals"
    )
      .with(query: { folderId: folder_id, status: status, sortBy: sort_by })
      .to_return_json(body: { value: [{ id: 'some-mural-3' }] })

    murals, = @client.murals.for_room(
      room_id,
      folder_id: folder_id,
      status: status,
      sort_by: sort_by
    )

    assert_equal 'some-mural-3', murals.first.id
  end

  def test_access_information
    mural_id = 'some-mural-4'
    mural_state = 'random-uuid-value'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/access-info"
    )
      .with(body: { muralState: mural_state })
      .to_return_json(
        body: { value: { visitors: 'none', workspaceMembers: 'write' } }
      )

    access_information = @client.murals.access_information(
      mural_id,
      mural_state: mural_state
    )

    assert_equal 'none', access_information.visitors
    assert_equal 'write', access_information.workspace_members
  end

  def test_reset_visitor_link
    mural_id = 'some-mural-5'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/visitor-settings" \
      '/reset-link'
    )
      .to_return_json(
        body: {
          value: {
            visitors: 'none',
            workspaceMembers: 'write',
            link: 'https://foobar.com/mural',
            expiresOn: 345
          }
        }
      )

    # Keeping names consistent, even if the typo is on Mural side.
    visitors_settings = @client.murals.reset_visitor_link(mural_id)

    assert_equal 'none', visitors_settings.visitors
    assert_equal 'write', visitors_settings.workspace_members
    assert_equal 'https://foobar.com/mural', visitors_settings.link
    assert_equal 345, visitors_settings.expires_on
  end

  def test_create
    stub_request(:post, 'https://app.mural.co/api/public/v1/murals')
      .with(body: { roomId: 1 })
      .to_return_json(body: { value: { id: 'created-mural-1' } }, status: 201)

    create_params = Mural::CreateMuralParams.new.tap do |params|
      params.room_id = 1
    end

    mural = @client.murals.create(create_params)

    assert_equal 'created-mural-1', mural.id
  end

  def test_create_with_link_expiring
    stub_request(:post, 'https://app.mural.co/api/public/v1/murals')
      .with(body: { roomId: 1, visitorsSettings: { expiresOn: 1 } })
      .to_return_json(body: { value: { id: 'created-mural-1' } }, status: 201)

    visitors_settings =
      Mural::CreateMuralParams::VisitorsSettings.new.tap do |settings|
        settings.expires_on = 1
      end

    create_params = Mural::CreateMuralParams.new.tap do |params|
      params.room_id = 1
      params.visitors_settings = visitors_settings
    end

    mural = @client.murals.create(create_params)

    assert_equal 'created-mural-1', mural.id
  end

  def test_update
    mural_id = 'some-mural-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}"
    )
      .with(body: { status: 'archived' })
      .to_return_json(body: { value: { id: mural_id, status: 'archived' } })

    update_params = Mural::UpdateMuralParams.new.tap do |params|
      params.status = 'archived'
    end

    mural = @client.murals.update(mural_id, update_params)

    assert_equal mural_id, mural.id
    assert_equal 'archived', mural.status
  end

  def test_destroy
    mural_id = 'mural-delete-1'

    delete_request = stub_request(
      :delete,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}"
    ).to_return(status: 204)

    @client.murals.destroy(mural_id)

    assert_requested delete_request
  end

  def test_duplicate
    mural_id = 'some-mural-9'
    target_room_id = 'target-room-1'
    target_folder_id = 'target-folder-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/duplicate"
    )
      .with(body: {})
      .to_return_json(
        body: {
          value: {
            id: 'duplicated-mural-1',
            roomId: target_room_id,
            folderId: target_folder_id,
            title: 'My duplicated mural'
          }
        },
        status: 201
      )

    duplicate_params = Mural::DuplicateMuralParams.new.tap do |params|
      params.room_id = target_room_id
      params.folder_id = target_folder_id
      params.title = 'My duplicated mural'
    end

    duplicated = @client.murals.duplicate(mural_id, duplicate_params)

    assert_equal 'duplicated-mural-1', duplicated.id
    assert_equal target_room_id, duplicated.room_id
    assert_equal target_folder_id, duplicated.folder_id
    assert_equal 'My duplicated mural', duplicated.title
  end
end
