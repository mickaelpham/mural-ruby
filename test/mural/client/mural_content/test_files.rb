# frozen_string_literal: true

require 'test_helper'

class TestAssets < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_file_params
    want = %i[
      height
      hidden
      instruction
      name
      parent_id
      presentation_index
      rotation
      stacking_order
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::CreateFileParams.attrs.keys.sort
  end

  def test_update_file_params
    want = %i[
      height
      hidden
      instruction
      parent_id
      presentation_index
      rotation
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::UpdateFileParams.attrs.keys.sort
  end

  def test_create_file
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/file"
    )
      .with(body: { name: 'my file', x: 5, y: 10 })
      .to_return_json(
        body: { value: { id: 'widget-1', type: 'file' } },
        status: 201
      )

    params = Mural::Widget::CreateFileParams.new.tap do |params|
      params.name = 'my file'
      params.x = 5
      params.y = 10
    end

    file = @client.mural_content.create_file(mural_id, params)

    assert_instance_of Mural::Widget::File, file
    assert_equal 'widget-1', file.id
  end

  def test_should_decode_content_edited_by
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/file"
    )
      .with(body: { name: 'my file', x: 5, y: 10 })
      .to_return_json(
        body: {
          value: {
            id: 'widget-1',
            contentEditedBy: { id: 'user-1', firstName: 'John' },
            type: 'file'
          }
        },
        status: 201
      )

    params = Mural::Widget::CreateFileParams.new.tap do |params|
      params.name = 'my file'
      params.x = 5
      params.y = 10
    end

    file = @client.mural_content.create_file(mural_id, params)

    assert_instance_of Mural::Widget::File, file
    assert_equal 'John', file.content_edited_by.first_name
  end

  def test_list_files
    mural_id = 'mural-2'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/files"
    ).to_return_json(
      body: { value: [{ id: 'file-1', type: 'file' }] }
    )

    files, = @client.mural_content.list_files(mural_id)

    assert_equal 1, files.size

    file = files.first

    assert_instance_of Mural::Widget::File, file
    assert_equal 'file-1', file.id
    assert_equal 'file', file.type
  end

  def test_update_file
    mural_id = 'mural-3'
    widget_id = 'widget-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/file/#{widget_id}"
    ).with(body: { presentationIndex: 2 })
      .to_return_json(body: { value: { id: widget_id, type: 'file' } })

    params = Mural::Widget::UpdateFileParams.new.tap do |params|
      params.presentation_index = 2
    end

    file = @client.mural_content.update_file(
      mural_id,
      widget_id: widget_id,
      update_file_params: params
    )

    assert_instance_of Mural::Widget::File, file
    assert_equal widget_id, file.id
    assert_equal 'file', file.type
  end
end
