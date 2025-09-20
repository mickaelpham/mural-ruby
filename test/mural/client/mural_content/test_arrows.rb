# frozen_string_literal: true

class TestArrows < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_arrow_params
    want = %i[
      arrow_type
      end_ref_id
      height
      instruction
      label
      parent_id
      points
      presentation_index
      rotation
      stackable
      stacking_order
      start_ref_id
      style
      tip
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::CreateArrowParams.attrs.keys.sort
  end

  def test_update_arrow_params
    want = %i[
      arrow_type
      end_ref_id
      height
      instruction
      label
      parent_id
      points
      presentation_index
      rotation
      stackable
      start_ref_id
      style
      tip
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::UpdateArrowParams.attrs.keys.sort
  end

  def test_create_minimal_arrow
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/arrow"
    ).with(
      body: {
        height: 1,
        width: 216,
        x: 0,
        y: 0,
        points: [
          { x: 216, y: 0 },
          { x: 0, y: 0 }
        ]
      }
    ).to_return_json(
      body: { value: { id: 'arrow-1', type: 'arrow' } },
      status: 201
    )

    create_arrow_params = Mural::Widget::CreateArrowParams.new.tap do |params|
      params.height = 1
      params.width = 216
      params.x = 0
      params.y = 0

      params.points = [
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 216
          p.y = 0
        end,
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 0
          p.y = 0
        end
      ]
    end

    arrow = @client.mural_content.create_arrow(mural_id, create_arrow_params)

    assert_instance_of Mural::Widget::Arrow, arrow
    assert_equal 'arrow-1', arrow.id
  end

  def test_should_decode_content_edited_by
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/arrow"
    ).with(
      body: {
        height: 1,
        width: 216,
        x: 0,
        y: 0,
        points: [
          { x: 216, y: 0 },
          { x: 0, y: 0 }
        ]
      }
    ).to_return_json(
      body: {
        value: {
          id: 'arrow-1',
          contentEditedBy: { id: 'user-1', firstName: 'John' },
          type: 'arrow'
        }
      },
      status: 201
    )

    create_arrow_params = Mural::Widget::CreateArrowParams.new.tap do |params|
      params.height = 1
      params.width = 216
      params.x = 0
      params.y = 0

      params.points = [
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 216
          p.y = 0
        end,
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 0
          p.y = 0
        end
      ]
    end

    arrow = @client.mural_content.create_arrow(mural_id, create_arrow_params)

    assert_instance_of Mural::Widget::Arrow, arrow
    assert_equal 'arrow-1', arrow.id
    assert_equal 'John', arrow.content_edited_by.first_name
  end

  def test_create_arrow_without_points
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/arrow"
    ).with(
      body: {
        height: 1,
        width: 216,
        x: 0,
        y: 0
      }
    ).to_return_json(
      body: {
        message: 'Invalid payload',
        code: 'BODY',
        details: [
          {
            code: 'Invalid property',
            message: 'Invalid "points" property type was sent. Type array ' \
                     'was expected.'
          }
        ]
      },
      status: 400
    )

    create_arrow_params = Mural::Widget::CreateArrowParams.new.tap do |params|
      params.height = 1
      params.width = 216
      params.x = 0
      params.y = 0
    end

    assert_raises(Mural::Error) do
      @client.mural_content.create_arrow(mural_id, create_arrow_params)
    end
  end

  def test_create_arrow_with_style_and_formatted_label
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/arrow"
    ).with(
      body: {
        height: 1,
        width: 216,
        x: 0,
        y: 0,
        points: [
          { x: 216, y: 0 },
          { x: 0, y: 0 }
        ],
        style: { strokeColor: '#FAFAFAFF' },
        label: { format: { fontFamily: 'proxima-nova' } }
      }
    ).to_return_json(
      body: { value: { id: 'arrow-1', type: 'arrow' } },
      status: 201
    )

    create_arrow_params = Mural::Widget::CreateArrowParams.new.tap do |params|
      params.height = 1
      params.width = 216
      params.x = 0
      params.y = 0

      params.points = [
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 216
          p.y = 0
        end,
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 0
          p.y = 0
        end
      ]

      params.style = Mural::Widget::CreateArrowParams::Style.new.tap do |style|
        style.stroke_color = '#FAFAFAFF'
      end

      params.label = Mural::Widget::CreateArrowParams::Label.new.tap do |label|
        label.format =
          Mural::Widget::CreateArrowParams::Label::Format.new.tap do |format|
            format.font_family = 'proxima-nova'
          end
      end
    end

    arrow = @client.mural_content.create_arrow(mural_id, create_arrow_params)

    assert_instance_of Mural::Widget::Arrow, arrow
    assert_equal 'arrow-1', arrow.id
  end

  def test_create_arrow_with_unformatted_labels
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/arrow"
    ).with(
      body: {
        height: 1,
        width: 216,
        x: 0,
        y: 0,
        points: [
          { x: 216, y: 0 },
          { x: 0, y: 0 }
        ],
        label: {
          labels: [
            { x: 0, y: 0, height: 12, width: 100, text: 'Arrow label' }
          ]
        }
      }
    ).to_return_json(
      body: { value: { id: 'arrow-1', type: 'arrow' } },
      status: 201
    )

    create_arrow_params = Mural::Widget::CreateArrowParams.new.tap do |params|
      params.height = 1
      params.width = 216
      params.x = 0
      params.y = 0

      params.points = [
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 216
          p.y = 0
        end,
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 0
          p.y = 0
        end
      ]

      params.label = Mural::Widget::CreateArrowParams::Label.new.tap do |label|
        label.labels = [
          Mural::Widget::CreateArrowParams::Label::Label.new.tap do |l|
            l.x = 0
            l.y = 0
            l.height = 12
            l.width = 100
            l.text = 'Arrow label'
          end
        ]
      end
    end

    arrow = @client.mural_content.create_arrow(mural_id, create_arrow_params)

    assert_instance_of Mural::Widget::Arrow, arrow
    assert_equal 'arrow-1', arrow.id
  end

  def test_update_arrow
    mural_id = 'mural-1'
    arrow_id = 'arrow-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      "/arrow/#{arrow_id}"
    ).with(
      body: {
        points: [
          { x: 216, y: 0 },
          { x: 0, y: 0 }
        ]
      }
    ).to_return_json(body: { value: { id: 'arrow-1', type: 'arrow' } })

    update_arrow_params = Mural::Widget::UpdateArrowParams.new.tap do |params|
      params.points = [
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 216
          p.y = 0
        end,
        Mural::Widget::Arrow::Point.new.tap do |p|
          p.x = 0
          p.y = 0
        end
      ]
    end

    arrow = @client.mural_content.update_arrow(
      mural_id,
      arrow_id,
      update_arrow_params
    )

    assert_instance_of Mural::Widget::Arrow, arrow
    assert_equal 'arrow-1', arrow.id
  end

  def test_update_arrow_with_style_and_formatted_label
    mural_id = 'mural-1'
    arrow_id = 'arrow-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      "/arrow/#{arrow_id}"
    ).with(
      body: {
        style: { strokeColor: '#FAFAFAFF' },
        label: { format: { fontFamily: 'proxima-nova' } }
      }
    ).to_return_json(body: { value: { id: 'arrow-1', type: 'arrow' } })

    update_arrow_params = Mural::Widget::UpdateArrowParams.new.tap do |params|
      params.style = Mural::Widget::UpdateArrowParams::Style.new.tap do |style|
        style.stroke_color = '#FAFAFAFF'
      end

      params.label = Mural::Widget::UpdateArrowParams::Label.new.tap do |label|
        label.format =
          Mural::Widget::UpdateArrowParams::Label::Format.new.tap do |format|
            format.font_family = 'proxima-nova'
          end
      end
    end

    arrow = @client.mural_content.update_arrow(
      mural_id,
      arrow_id,
      update_arrow_params
    )

    assert_instance_of Mural::Widget::Arrow, arrow
    assert_equal 'arrow-1', arrow.id
  end
end
