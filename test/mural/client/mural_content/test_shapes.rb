# frozen_string_literal: true

class TestShapes < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_shape_params
    want = %i[
      height
      hidden
      html_text
      instruction
      parent_id
      presentation_index
      rotation
      shape
      stacking_order
      style
      text
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::CreateShapeParams.attrs.keys.sort
  end

  def test_update_shape_params
    want = %i[
      height
      hidden
      html_text
      instruction
      parent_id
      presentation_index
      rotation
      style
      text
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::UpdateShapeParams.attrs.keys.sort
  end

  def test_create_shapes
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/shape"
    )
      .with(
        body: [
          { shape: 'rectangle', x: 0, y: 0 },
          {
            shape: 'ellipse',
            x: 1,
            y: 1,
            style: { backgroundColor: '#FAFAFAFF' }
          }
        ]
      )
      .to_return_json(
        body: {
          value: [
            { id: 'shape-1', shape: 'rectangle' },
            {
              id: 'shape-2',
              shape: 'ellipse',
              style: { backgroundColor: '#FAFAFAFF' }
            }
          ]
        },
        status: 201
      )

    create_shape_params = [
      Mural::Widget::CreateShapeParams.new.tap do |params|
        params.shape = 'rectangle'
        params.x = 0
        params.y = 0
      end,
      Mural::Widget::CreateShapeParams.new.tap do |params|
        params.shape = 'ellipse'
        params.x = 1
        params.y = 1
        params.style =
          Mural::Widget::UpdateShapeParams::Style.new.tap do |style|
            style.background_color = '#FAFAFAFF'
          end
      end
    ]

    shapes = @client.mural_content.create_shapes(
      mural_id,
      create_shape_params
    )

    assert_equal 2, shapes.size

    rectangle = shapes.find { |s| s.shape == 'rectangle' }

    assert_instance_of Mural::Widget::Shape, rectangle
    assert_equal 'shape-1', rectangle.id

    ellipse = shapes.find { |s| s.shape == 'ellipse' }

    assert_instance_of Mural::Widget::Shape, ellipse
    assert_equal 'shape-2', ellipse.id
    assert_equal '#FAFAFAFF', ellipse.style.background_color
  end

  def test_update_shape
    mural_id = 'mural-1'
    shape_id = 'shape-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      "/shape/#{shape_id}"
    )
      .with(body: { title: 'dat shape' })
      .to_return_json(
        body: { value: { id: 'shape-1', title: 'dat shape' } },
        status: 201
      )

    update_shape_params =
      Mural::Widget::UpdateShapeParams.new.tap do |params|
        params.title = 'dat shape'
      end

    shape = @client.mural_content.update_shape(
      mural_id,
      shape_id,
      update_shape_params
    )

    assert_instance_of Mural::Widget::Shape, shape
    assert_equal 'shape-1', shape.id
    assert_equal 'dat shape', shape.title
  end

  def test_update_shape_with_style
    mural_id = 'mural-1'
    shape_id = 'shape-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      "/shape/#{shape_id}"
    )
      .with(body: { style: { backgroundColor: '#FAFAFAFF' } })
      .to_return_json(
        body: { value: { id: 'shape-1' } },
        status: 201
      )

    update_shape_params =
      Mural::Widget::UpdateShapeParams.new.tap do |params|
        params.style =
          Mural::Widget::UpdateShapeParams::Style.new.tap do |style|
            style.background_color = '#FAFAFAFF'
          end
      end

    shape = @client.mural_content.update_shape(
      mural_id,
      shape_id,
      update_shape_params
    )

    assert_instance_of Mural::Widget::Shape, shape
    assert_equal 'shape-1', shape.id
  end
end
