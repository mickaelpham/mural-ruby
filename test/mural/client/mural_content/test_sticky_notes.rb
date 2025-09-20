# frozen_string_literal: true

require 'test_helper'

class TestStickyNotes < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_sticky_note_params
    want = %i[
      height
      hidden
      html_text
      hyperlink
      hyperlink_title
      instruction
      parent_id
      presentation_index
      rotation
      shape
      stacking_order
      style
      tags
      text
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::CreateStickyNoteParams.attrs.keys.sort
  end

  def test_update_sticky_note_params
    want = %i[
      height
      hidden
      html_text
      hyperlink
      hyperlink_title
      instruction
      parent_id
      presentation_index
      rotation
      style
      tags
      text
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::UpdateStickyNoteParams.attrs.keys.sort
  end

  def test_create_sticky_notes
    mural_id = 'some-mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      '/sticky-note'
    )
      .with(body: [{ text: 'My sticky' }])
      .to_return_json(body: { value: [{ id: 'sticky-1' }] }, status: 201)

    create_sticky_note_params =
      Mural::Widget::CreateStickyNoteParams.new.tap do |sticky_note|
        sticky_note.text = 'My sticky'
      end

    created_sticky_notes =
      @client
      .mural_content
      .create_sticky_notes(mural_id, create_sticky_note_params)

    assert_equal 1, created_sticky_notes.size
    assert_equal 'sticky-1', created_sticky_notes.first.id
  end

  def test_create_sticky_notes_with_style
    mural_id = 'some-mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      '/sticky-note'
    )
      .with(
        body: [{ text: 'My sticky', style: { backgroundColor: '#FAFAFAFF' } }]
      )
      .to_return_json(
        body: { value: [{ id: 'sticky-1' }] },
        status: 201
      )

    create_sticky_note_params =
      Mural::Widget::CreateStickyNoteParams.new.tap do |sticky_note|
        sticky_note.text = 'My sticky'
        sticky_note.style =
          Mural::Widget::CreateStickyNoteParams::Style.new.tap do |style|
            style.background_color = '#FAFAFAFF'
          end
      end

    created_sticky_notes =
      @client
      .mural_content
      .create_sticky_notes(mural_id, create_sticky_note_params)

    assert_equal 1, created_sticky_notes.size
    assert_equal 'sticky-1', created_sticky_notes.first.id
  end

  def test_update_sticky_note
    mural_id = 'mural-1'
    widget_id = 'sticky-note-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      "/sticky-note/#{widget_id}"
    )
      .with(body: { text: 'updated text' })
      .to_return_json(body: { value: { id: widget_id } })

    update_params =
      Mural::Widget::UpdateStickyNoteParams.new.tap do |params|
        params.text = 'updated text'
      end

    updated = @client.mural_content
                     .update_sticky_note(mural_id, widget_id, update_params)

    assert_equal widget_id, updated.id
  end

  def test_update_sticky_note_with_style
    mural_id = 'mural-1'
    widget_id = 'sticky-note-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets" \
      "/sticky-note/#{widget_id}"
    )
      .with(body: { style: { bold: true } })
      .to_return_json(body: { value: { id: widget_id } })

    update_params =
      Mural::Widget::UpdateStickyNoteParams.new.tap do |params|
        params.style =
          Mural::Widget::UpdateStickyNoteParams::Style.new.tap do |style|
            style.bold = true
          end
      end

    updated = @client.mural_content
                     .update_sticky_note(mural_id, widget_id, update_params)

    assert_equal widget_id, updated.id
  end
end
