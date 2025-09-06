# frozen_string_literal: true

require 'test_helper'

class TestTags < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_list_tags
    mural_id = 'mural-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/tags"
    ).to_return_json(
      body: {
        value: [
          {
            id: 'tag-1',
            text: 'My tag',
            backgroundColor: '#FAFAFAFF',
            borderColor: '#FAFAFAFF',
            color: '#FAFAFAFF'
          }
        ]
      }
    )

    tags = @client.mural_content.list_tags(mural_id)

    assert_equal 1, tags.size

    tag = tags.first

    assert_equal 'tag-1', tag.id
    assert_equal 'My tag', tag.text
    assert_equal '#FAFAFAFF', tag.background_color
    assert_equal '#FAFAFAFF', tag.border_color
    assert_equal '#FAFAFAFF', tag.color
  end

  def test_retrieve_tag
    mural_id = 'mural-1'
    tag_id = 'tag-2'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/tags/#{tag_id}"
    ).to_return_json(
      body: {
        value: {
          id: tag_id,
          text: 'My 2nd tag',
          backgroundColor: '#FAFAFAFF',
          borderColor: '#FAFAFAFF',
          color: '#FAFAFAFF'
        }
      }
    )

    tag = @client.mural_content.retrieve_tag(mural_id, tag_id)

    assert_equal tag_id, tag.id
    assert_equal 'My 2nd tag', tag.text
    assert_equal '#FAFAFAFF', tag.background_color
    assert_equal '#FAFAFAFF', tag.border_color
    assert_equal '#FAFAFAFF', tag.color
  end

  def test_create_tag
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/tags"
    ).with(
      body: {
        text: 'My tag',
        backgroundColor: '#FAFAFAFF',
        borderColor: '#FAFAFAFF',
        color: '#FAFAFAFF',
        widgets: [{ id: 'widget-1' }, { id: 'widget-2' }]
      }
    ).to_return_json(
      body: { value: { id: 'tag-1' } },
      status: 201
    )

    add_to_widgets = %w[widget-1 widget-2].map do |widget_id|
      Mural::CreateTagParams::Widget.new.tap do |widget|
        widget.id = widget_id
      end
    end

    create_tag_params = Mural::CreateTagParams.new.tap do |params|
      params.text = 'My tag'
      params.background_color = '#FAFAFAFF'
      params.border_color = '#FAFAFAFF'
      params.color = '#FAFAFAFF'
      params.widgets = add_to_widgets
    end

    created_tag = @client.mural_content.create_tag(mural_id, create_tag_params)

    assert_equal 'tag-1', created_tag.id
  end

  def test_create_tag_without_adding_to_widgets
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/tags"
    ).with(
      body: {
        text: 'My tag',
        backgroundColor: '#FAFAFAFF',
        borderColor: '#FAFAFAFF',
        color: '#FAFAFAFF'
      }
    ).to_return_json(
      body: { value: { id: 'tag-1' } },
      status: 201
    )

    create_tag_params = Mural::CreateTagParams.new.tap do |params|
      params.text = 'My tag'
      params.background_color = '#FAFAFAFF'
      params.border_color = '#FAFAFAFF'
      params.color = '#FAFAFAFF'
    end

    created_tag = @client.mural_content.create_tag(mural_id, create_tag_params)

    assert_equal 'tag-1', created_tag.id
  end

  def test_update_tag
    mural_id = 'mural-1'
    tag_id = 'tag-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/tags/#{tag_id}"
    ).with(
      body: {
        text: 'My tag',
        backgroundColor: '#FAFAFAFF',
        borderColor: '#FAFAFAFF',
        color: '#FAFAFAFF'
      }
    ).to_return_json(
      body: { value: { id: 'tag-1' } }
    )

    update_tag_params = Mural::UpdateTagParams.new.tap do |params|
      params.text = 'My tag'
      params.background_color = '#FAFAFAFF'
      params.border_color = '#FAFAFAFF'
      params.color = '#FAFAFAFF'
    end

    updated_tag =
      @client.mural_content.update_tag(mural_id, tag_id, update_tag_params)

    assert_equal 'tag-1', updated_tag.id
  end

  def test_destroy_tag
    mural_id = 'mural-1'
    tag_id = 'tag-1'

    delete_request = stub_request(
      :delete,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/tags/#{tag_id}"
    ).to_return(status: 204)

    @client.mural_content.destroy_tag(mural_id, tag_id)

    assert_requested delete_request
  end
end
