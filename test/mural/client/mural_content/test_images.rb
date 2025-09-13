# frozen_string_literal: true

require 'test_helper'

class TestImages < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_image
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/image"
    )
      .with(body: { name: 'my image' })
      .to_return_json(
        body: {
          value: {
            id: 'image-1',
            thumbnailUrl: 'https://example.com/thumbnail.jpg'
          }
        },
        status: 201
      )

    params = Mural::Widget::CreateImageParams.new.tap do |params|
      params.name = 'my image'
    end

    image = @client.mural_content.create_image(mural_id, params)

    assert_instance_of Mural::Widget::Image, image
    assert_equal 'image-1', image.id
    assert_equal 'https://example.com/thumbnail.jpg', image.thumbnail_url
  end

  def test_update_image
    mural_id = 'mural-1'
    image_id = 'image-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      "/image/#{image_id}"
    )
      .with(body: { showCaption: false })
      .to_return_json(
        body: { value: { id: 'image-1' } },
        status: 201
      )

    params = Mural::Widget::UpdateImageParams.new.tap do |params|
      params.show_caption = false
    end

    image = @client.mural_content.update_image(mural_id, image_id, params)

    assert_instance_of Mural::Widget::Image, image
    assert_equal 'image-1', image.id
  end
end
