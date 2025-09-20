# frozen_string_literal: true

class TestTitles < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_title_params
    want = %i[
      height
      hidden
      hyperlink
      hyperlink_title
      instruction
      parent_id
      presentation_index
      rotation
      stacking_order
      style
      text
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::CreateTitleParams.attrs.keys.sort
  end

  def test_update_title_params
    want = %i[
      height
      hidden
      hyperlink
      hyperlink_title
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

    assert_equal want, Mural::Widget::UpdateTitleParams.attrs.keys.sort
  end

  def test_create_titles
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/title"
    )
      .with(
        body: [
          { text: 'Hello world' },
          { text: 'Bonjour monde', style: { backgroundColor: '#FAFAFAFF' } }
        ]
      )
      .to_return_json(
        body: { value: [
          { id: 'title-1', text: 'Hello world' },
          {
            id: 'title-2',
            text: 'Bonjour monde',
            style: { backgroundColor: '#FAFAFAFF' }
          }
        ] },
        status: 201
      )

    create_title_params = [
      Mural::Widget::CreateTitleParams.new.tap do |t|
        t.text = 'Hello world'
      end,

      Mural::Widget::CreateTitleParams.new.tap do |t|
        t.text = 'Bonjour monde'
        t.style = Mural::Widget::CreateTitleParams::Style.new.tap do |s|
          s.background_color = '#FAFAFAFF'
        end
      end
    ]

    titles = @client.mural_content.create_titles(mural_id, create_title_params)

    assert_equal 2, titles.size

    regular_title = titles.first

    assert_instance_of Mural::Widget::Text, regular_title
    assert_equal 'Hello world', regular_title.text

    title_with_style = titles.last

    assert_instance_of Mural::Widget::Text, title_with_style
    assert_equal 'Bonjour monde', title_with_style.text
    assert_equal '#FAFAFAFF', title_with_style.style.background_color
  end

  def test_update_title
    mural_id = 'mural-1'
    title_id = 'title-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/title/#{title_id}"
    )
      .with(body: { text: 'Hola mundo' })
      .to_return_json(
        body: { value: { id: title_id, text: 'Hola mundo' } }
      )

    update_title_params = Mural::Widget::UpdateTitleParams.new.tap do |t|
      t.text = 'Hola mundo'
    end

    title = @client
            .mural_content
            .update_title(mural_id, title_id, update_title_params)

    assert_instance_of Mural::Widget::Text, title
    assert_equal title_id, title.id
    assert_equal 'Hola mundo', title.text
  end

  def test_update_title_with_style
    mural_id = 'mural-1'
    title_id = 'title-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/title/#{title_id}"
    )
      .with(body: { style: { backgroundColor: '#FAFAFAFF' } })
      .to_return_json(
        body: {
          value: { id: title_id, style: { backgroundColor: '#FAFAFAFF' } }
        }
      )

    update_title_params = Mural::Widget::UpdateTitleParams.new.tap do |t|
      t.style = Mural::Widget::UpdateTitleParams::Style.new.tap do |s|
        s.background_color = '#FAFAFAFF'
      end
    end

    title = @client
            .mural_content
            .update_title(mural_id, title_id, update_title_params)

    assert_instance_of Mural::Widget::Text, title
    assert_equal title_id, title.id
    assert_equal '#FAFAFAFF', title.style.background_color
  end
end
