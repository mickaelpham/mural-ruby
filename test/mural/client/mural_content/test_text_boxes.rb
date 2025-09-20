# frozen_string_literal: true

class TestTextBoxes < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_text_boxes
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/textbox"
    )
      .with(
        body: [
          { text: 'Hello world' },
          { text: 'Bonjour monde', style: { backgroundColor: '#FAFAFAFF' } }
        ]
      )
      .to_return_json(
        body: { value: [
          { id: 'text-box-1', text: 'Hello world' },
          {
            id: 'text-box-2',
            text: 'Bonjour monde',
            style: { backgroundColor: '#FAFAFAFF' }
          }
        ] },
        status: 201
      )

    create_text_box_params = [
      Mural::Widget::CreateTextBoxParams.new.tap do |t|
        t.text = 'Hello world'
      end,

      Mural::Widget::CreateTextBoxParams.new.tap do |t|
        t.text = 'Bonjour monde'
        t.style = Mural::Widget::CreateTextBoxParams::Style.new.tap do |s|
          s.background_color = '#FAFAFAFF'
        end
      end
    ]

    text_boxes = @client.mural_content.create_text_boxes(
      mural_id,
      create_text_box_params
    )

    assert_equal 2, text_boxes.size

    text_box = text_boxes.first

    assert_instance_of Mural::Widget::Text, text_box
    assert_equal 'Hello world', text_box.text

    text_box_with_style = text_boxes.last

    assert_instance_of Mural::Widget::Text, text_box_with_style
    assert_equal 'Bonjour monde', text_box_with_style.text
    assert_equal '#FAFAFAFF', text_box_with_style.style.background_color
  end

  def test_update_text_box
    mural_id = 'mural-1'
    text_box_id = 'text-box-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/textbox/#{text_box_id}"
    )
      .with(body: { text: 'Hola mundo' })
      .to_return_json(
        body: { value: { id: text_box_id, text: 'Hola mundo' } }
      )

    update_text_box_params = Mural::Widget::UpdateTextBoxParams.new.tap do |t|
      t.text = 'Hola mundo'
    end

    text_box = @client
               .mural_content
               .update_text_box(mural_id, text_box_id, update_text_box_params)

    assert_instance_of Mural::Widget::Text, text_box
    assert_equal text_box_id, text_box.id
    assert_equal 'Hola mundo', text_box.text
  end

  def test_update_text_box_with_style
    mural_id = 'mural-1'
    text_box_id = 'text-box-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/textbox/#{text_box_id}"
    )
      .with(body: { style: { backgroundColor: '#FAFAFAFF' } })
      .to_return_json(
        body: {
          value: { id: text_box_id, style: { backgroundColor: '#FAFAFAFF' } }
        }
      )

    update_text_box_params = Mural::Widget::UpdateTextBoxParams.new.tap do |t|
      t.style = Mural::Widget::UpdateTextBoxParams::Style.new.tap do |s|
        s.background_color = '#FAFAFAFF'
      end
    end

    text_box = @client
               .mural_content
               .update_text_box(mural_id, text_box_id, update_text_box_params)

    assert_instance_of Mural::Widget::Text, text_box
    assert_equal text_box_id, text_box.id
    assert_equal '#FAFAFAFF', text_box.style.background_color
  end
end
