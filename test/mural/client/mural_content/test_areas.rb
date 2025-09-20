# frozen_string_literal: true

class TestAreas < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_area_params
    want = %i[
      height
      hidden
      instruction
      layout
      parent_id
      presentation_index
      show_title
      stacking_order
      style
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::CreateAreaParams.attrs.keys.sort
  end

  def test_update_area_params
    want = %i[
      height
      hidden
      instruction
      layout
      parent_id
      presentation_index
      show_title
      style
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::UpdateAreaParams.attrs.keys.sort
  end

  def test_create_area
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/area"
    ).with(body: { title: 'Nothing to see here' })
      .to_return_json(
        body: { value: { id: 'area-51' } },
        status: 201
      )

    create_area_params = Mural::Widget::CreateAreaParams.new.tap do |params|
      params.title = 'Nothing to see here'
    end

    area = @client.mural_content.create_area(mural_id, create_area_params)

    assert_instance_of Mural::Widget::Area, area
  end

  def test_create_area_with_style
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/area"
    ).with(
      body: { title: 'Todo', style: { backgroundColor: '#FFFFFF33' } }
    )
      .to_return_json(
        body: { value: { id: 'area-1' } },
        status: 201
      )

    create_area_params = Mural::Widget::CreateAreaParams.new.tap do |params|
      params.title = 'Todo'
      params.style = Mural::Widget::CreateAreaParams::Style.new.tap do |style|
        style.background_color = '#FFFFFF33'
      end
    end

    area = @client.mural_content.create_area(mural_id, create_area_params)

    assert_instance_of Mural::Widget::Area, area
  end

  def test_update_area
    mural_id = 'mural-1'
    area_id = 'area-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      "/area/#{area_id}"
    ).with(body: { title: 'updated title' })
      .to_return_json(body: { value: { id: 'area-1' } })

    update_area_params = Mural::Widget::UpdateAreaParams.new.tap do |params|
      params.title = 'updated title'
    end

    updated_area =
      @client.mural_content.update_area(mural_id, area_id, update_area_params)

    assert_instance_of Mural::Widget::Area, updated_area
    assert_equal 'area-1', updated_area.id
  end

  def test_update_area_with_style
    mural_id = 'mural-1'
    area_id = 'area-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      "/area/#{area_id}"
    ).with(body: { style: { backgroundColor: '#FAFAFAFF' } })
      .to_return_json(body: { value: { id: 'area-1' } })

    update_area_params = Mural::Widget::UpdateAreaParams.new.tap do |params|
      params.style = Mural::Widget::UpdateAreaParams::Style.new.tap do |style|
        style.background_color = '#FAFAFAFF'
      end
    end

    updated_area =
      @client.mural_content.update_area(mural_id, area_id, update_area_params)

    assert_instance_of Mural::Widget::Area, updated_area
    assert_equal 'area-1', updated_area.id
  end
end
