# frozen_string_literal: true

require 'test_helper'

class TestWidgets < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_list_widgets
    mural_id = 'some-mural-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets"
    ).to_return_json(
      body: { value: [
        { id: 'area-1', type: 'area' },
        { id: 'arrow-1', type: 'arrow' },
        { id: 'comment-1', type: 'comment' },
        { id: 'file-1', type: 'file' },
        { id: 'table-1', type: 'table' },
        { id: 'unknown-1', type: 'unknown' }
      ] }
    )

    widgets, = @client.mural_content.list_widgets(mural_id)

    area = widgets.find { |w| w.is_a? Mural::Widget::Area }

    refute_nil area
    assert_instance_of Mural::Widget::Area, area
    assert_equal 'area-1', area.id

    file = widgets.find { |w| w.is_a? Mural::Widget::File }

    refute_nil file
    assert_instance_of Mural::Widget::File, file
    assert_equal 'file-1', file.id

    arrow = widgets.find { |w| w.is_a? Mural::Widget::Arrow }

    refute_nil arrow
    assert_instance_of Mural::Widget::Arrow, arrow
    assert_equal 'arrow-1', arrow.id

    comment = widgets.find { |w| w.is_a? Mural::Widget::Comment }

    refute_nil comment
    assert_instance_of Mural::Widget::Comment, comment
    assert_equal 'comment-1', comment.id

    table = widgets.find { |w| w.is_a? Mural::Widget::Table }

    refute_nil table
    assert_instance_of Mural::Widget::Table, table
    assert_equal 'table-1', table.id

    unknown_widget = widgets.find { |w| w.is_a? Mural::Widget }

    refute_nil unknown_widget
    assert_equal 'unknown-1', unknown_widget.id
  end

  def test_retrieve_arrow_widget
    mural_id = 'mural-1'
    widget_id = 'arrow-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return_json(
      body: {
        value: {
          contentEditedBy: {
            firstName: 'Napoléon',
            id: 'user-1',
            lastName: 'Bonaparte'
          },
          contentEditedOn: 1_757_084_844_408,
          createdBy: {
            firstName: 'Napoléon',
            id: 'user-1',
            lastName: 'Bonaparte'
          },
          createdOn: 1_757_083_600_172,
          height: 155.3800000000001,
          hidden: false,
          hideEditor: false,
          hideOwner: false,
          id: 'arrow-1',
          instruction: '',
          invisible: false,
          locked: false,
          lockedByFacilitator: false,
          parentId: nil,
          presentationIndex: -1,
          rotation: 0,
          stackingOrder: 1,
          title: '',
          updatedBy: {
            firstName: 'Napoléon',
            id: 'user-1',
            lastName: 'Bonaparte'
          },
          updatedOn: 1_757_084_844_409,
          width: 452.4,
          x: 1308.84,
          y: 954,
          arrowType: 'orthogonal',
          endRefId: nil,
          label: {
            format: {
              bold: true,
              strike: false,
              italic: false,
              color: '#000000FF',
              underline: false,
              fontSize: 36,
              fontFamily: 'proxima-nova',
              textAlign: 'center'
            },
            labels: [
              {
                height: 44,
                text: 'bonjour',
                width: 137,
                x: 157,
                y: 55,
                newText: 'bonjour'
              }
            ]
          },
          points: [
            {
              x: 452.4,
              y: 155.38
            },
            {
              x: 226.2,
              y: 155.38
            },
            {
              x: 226.2,
              y: 0
            },
            {
              x: 0,
              y: 0
            }
          ],
          stackable: true,
          startRefId: nil,
          style: {
            strokeColor: '#1F1F1FFF',
            strokeStyle: 'solid',
            strokeWidth: 3
          },
          tip: 'single',
          type: 'arrow'
        }
      }
    )

    arrow = @client.mural_content.retrieve_widget(mural_id, widget_id)

    assert_instance_of Mural::Widget::Arrow, arrow
    assert_equal widget_id, arrow.id
    assert_equal 4, arrow.points.size
    assert_equal 1, arrow.label.labels.size
    assert_equal 'proxima-nova', arrow.label.format.font_family
  end

  def test_retrieve_comment_widget
    mural_id = 'mural-1'
    widget_id = 'comment-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return_json(
      body: {
        value: {
          contentEditedBy: {
            firstName: 'Alphonse',
            id: 'user-1',
            lastName: 'Elric'
          },
          contentEditedOn: 0,
          createdBy: {
            firstName: 'Alphonse',
            id: 'user-1',
            lastName: 'Elric'
          },
          createdOn: 1_757_105_935_640,
          height: 46,
          hidden: false,
          hideEditor: false,
          hideOwner: false,
          id: 'comment-1',
          instruction: '',
          invisible: false,
          locked: false,
          lockedByFacilitator: false,
          parentId: nil,
          presentationIndex: -1,
          rotation: 0,
          stackingOrder: 1,
          title: '',
          updatedBy: {
            firstName: 'Alphonse',
            id: 'user-1',
            lastName: 'Elric'
          },
          updatedOn: 1_757_105_948_167,
          width: 46,
          x: 1651.910951803673,
          y: 359.3914056073749,
          message: "I'd like to understand",
          referenceWidgetId: 'sticky-1',
          replies: [
            {
              created: 1_757_105_940_139,
              message: 'How is this supposed to work?',
              user: {
                firstName: 'Alphonse',
                id: 'user-1',
                lastName: 'Elric'
              }
            },
            {
              created: 1_757_105_945_187,
              message: 'And why is it good?',
              user: {
                firstName: 'Alphonse',
                id: 'user-1',
                lastName: 'Elric'
              }
            }
          ],
          resolvedBy: {
            firstName: 'Alphonse',
            id: 'user-1',
            lastName: 'Elric'
          },
          resolvedOn: 1_757_105_948_167,
          timestamp: 1_757_105_929_201,
          type: 'comment'
        }
      }
    )

    comment = @client.mural_content.retrieve_widget(mural_id, widget_id)

    assert_instance_of Mural::Widget::Comment, comment
    assert_equal widget_id, comment.id
    assert_equal 2, comment.replies.size
  end

  def test_retrieve_icon_widget
    mural_id = 'mural-1'
    widget_id = 'icon-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return_json(
      body: {
        value: {
          contentEditedBy: {
            firstName: 'Edward',
            id: 'user-3',
            lastName: 'Elric'
          },
          contentEditedOn: 0,
          createdBy: {
            firstName: 'Edward',
            id: 'user-3',
            lastName: 'Elric'
          },
          createdOn: 1_757_142_268_123,
          height: 40,
          hidden: false,
          hideEditor: false,
          hideOwner: false,
          id: widget_id,
          instruction: '',
          invisible: false,
          locked: false,
          lockedByFacilitator: false,
          parentId: nil,
          presentationIndex: -1,
          rotation: 0,
          stackingOrder: 0,
          title: '',
          updatedBy: {
            firstName: 'Edward',
            id: 'user-3',
            lastName: 'Elric'
          },
          updatedOn: 1_757_142_268_123,
          width: 40,
          x: 1512,
          y: 272,
          name: '940622',
          style: {
            color: '#1F1F1FFF'
          },
          type: 'icon'
        }
      }
    )

    icon = @client.mural_content.retrieve_widget(mural_id, widget_id)

    assert_instance_of Mural::Widget::Icon, icon
    assert_equal widget_id, icon.id
    assert_equal '#1F1F1FFF', icon.style.color
    assert_equal '940622', icon.name
  end

  def test_retrieve_image_widget
    mural_id = 'mural-1'
    widget_id = 'image-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return_json(
      body: {
        value: {
          contentEditedBy: {
            firstName: 'Colonel',
            id: 'user-4',
            lastName: 'Mustang'
          },
          contentEditedOn: 0,
          createdBy: {
            firstName: 'Colonel',
            id: 'user-4',
            lastName: 'Mustang'
          },
          createdOn: 1_757_143_526_598,
          height: 490,
          hidden: false,
          hideEditor: false,
          hideOwner: false,
          id: 'image-1',
          instruction: '',
          invisible: false,
          locked: false,
          lockedByFacilitator: false,
          parentId: nil,
          presentationIndex: -1,
          rotation: 0,
          stackingOrder: 0,
          updatedBy: {
            firstName: 'Colonel',
            id: 'user-4',
            lastName: 'Mustang'
          },
          updatedOn: 1_757_143_570_092,
          width: 724,
          x: 953.9110107421875,
          y: 192.28529600805166,
          expiresInMinutes: 4,
          url: 'https://example.com/uploads/image.jpg',
          aspectRatio: 1.4775510204081632,
          border: false,
          caption: '',
          description: '',
          link: nil,
          mask: {
            height: 490,
            left: 24,
            top: 0,
            width: 724
          },
          naturalHeight: 540.2122448979592,
          naturalWidth: 1024,
          showCaption: true,
          thumbnailUrl: '',
          type: 'image'
        }
      }
    )

    image = @client.mural_content.retrieve_widget(mural_id, widget_id)

    assert_instance_of Mural::Widget::Image, image
    assert_equal widget_id, image.id
    assert_equal 490, image.mask.height
    assert_equal 1024, image.natural_width
  end

  def test_retrieve_shape_widget
    mural_id = 'mural-1'
    widget_id = 'shape-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return_json(
      body: {
        value: {
          contentEditedBy: {
            firstName: 'Mr.',
            id: 'user-9',
            lastName: 'Wolf'
          },
          contentEditedOn: 1_757_144_507_601,
          createdBy: {
            firstName: 'Mr.',
            id: 'user-9',
            lastName: 'Wolf'
          },
          createdOn: 1_757_144_472_053,
          height: 182,
          hidden: false,
          hideEditor: false,
          hideOwner: false,
          id: widget_id,
          instruction: '',
          invisible: false,
          locked: false,
          lockedByFacilitator: false,
          parentId: nil,
          presentationIndex: -1,
          rotation: 0,
          stackingOrder: 0,
          title: '',
          updatedBy: {
            firstName: 'Mr.',
            id: 'user-9',
            lastName: 'Wolf'
          },
          updatedOn: 1_757_144_520_640,
          width: 182,
          x: 1258,
          y: -168,
          htmlText: '<html v="1"><div><b><span style="color:#f7f7f7">STOP' \
                    '</span></b></div></html>',
          shape: 'octagon',
          style: {
            backgroundColor: '#BF0C0CFF',
            bold: false,
            borderColor: '#1F1F1FFF',
            borderStyle: 'solid',
            borderWidth: 4,
            font: 'proxima-nova',
            fontColor: '#000000FF',
            fontSize: 48,
            italic: false,
            strike: false,
            textAlign: 'center',
            underline: false
          },
          text: '',
          type: 'shape'
        }
      }
    )

    shape = @client.mural_content.retrieve_widget(mural_id, widget_id)

    assert_instance_of Mural::Widget::Shape, shape
    assert_equal widget_id, shape.id
    assert_equal '#BF0C0CFF', shape.style.background_color
    assert_equal(
      '<html v="1"><div><b><span style="color:#f7f7f7">STOP</span>' \
      '</b></div></html>',
      shape.html_text
    )
  end

  def test_retrieve_sticky_note_widget
    mural_id = 'mural-1'
    widget_id = 'sticky-note-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return_json(
      body: {
        value: {
          contentEditedBy: {
            firstName: 'Marvin',
            id: 'user-42'
          },
          contentEditedOn: 1_757_145_416_708,
          createdBy: {
            firstName: 'Marvin',
            id: 'user-42'
          },
          createdOn: 1_757_145_174_131,
          height: 168,
          hidden: false,
          hideEditor: false,
          hideOwner: false,
          id: widget_id,
          instruction: '',
          invisible: false,
          locked: false,
          lockedByFacilitator: false,
          parentId: nil,
          presentationIndex: -1,
          rotation: 0,
          stackingOrder: 0,
          title: '',
          updatedBy: {
            firstName: 'Marvin',
            id: 'user-42'
          },
          updatedOn: 1_757_145_416_708,
          width: 168,
          x: 1176,
          y: -192,
          htmlText: '<html v="1"><div><a><i><b><span>H2G2</span></b></i></a>' \
                    '</div></html>',
          hyperlink: 'https://www.imdb.com/title/tt0371724/',
          hyperlinkTitle: '',
          minLines: 3,
          shape: 'rectangle',
          style: {
            backgroundColor: '#FCB6D4FF',
            bold: false,
            border: false,
            font: 'proxima-nova',
            fontSize: 36,
            italic: false,
            strike: false,
            textAlign: 'center',
            underline: false
          },
          tags: [
            'tag-123'
          ],
          text: '',
          type: 'sticky note'
        }
      }
    )

    sticky_note = @client.mural_content.retrieve_widget(mural_id, widget_id)

    assert_instance_of Mural::Widget::StickyNote, sticky_note
    assert_equal widget_id, sticky_note.id
    assert_equal 'tag-123', sticky_note.tags.first
    assert_equal 36, sticky_note.style.font_size
    assert_equal(
      '<html v="1"><div><a><i><b><span>H2G2</span></b></i></a></div></html>',
      sticky_note.html_text
    )
  end

  def test_retrieve_text_widget
    mural_id = 'mural-1'
    widget_id = 'text-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return_json(
      body: {
        value: {
          contentEditedBy: {
            firstName: 'Capitaine',
            id: 'user-1',
            lastName: 'Haddock'
          },
          contentEditedOn: 1_757_146_090_910,
          createdBy: {
            firstName: 'Capitaine',
            id: 'user-1',
            lastName: 'Haddock'
          },
          createdOn: 1_757_146_082_532,
          height: 75.2583984375,
          hidden: false,
          hideEditor: false,
          hideOwner: false,
          id: 'text-1',
          instruction: '',
          invisible: false,
          locked: false,
          lockedByFacilitator: false,
          parentId: nil,
          presentationIndex: -1,
          rotation: 0,
          stackingOrder: 0,
          title: '',
          updatedBy: {
            firstName: 'Capitaine',
            id: 'user-1',
            lastName: 'Haddock'
          },
          updatedOn: 1_757_146_090_910,
          width: 421,
          x: 1101,
          y: -240,
          fixedWidth: false,
          style: {
            backgroundColor: '#FFFFFF00',
            font: 'proxima-nova',
            fontSize: 60,
            textAlign: 'left'
          },
          text: '<html v="1"><div><span>Get started</span></div></html>',
          type: 'text'
        }
      }
    )

    text = @client.mural_content.retrieve_widget(mural_id, widget_id)

    assert_instance_of Mural::Widget::Text, text
    assert_equal widget_id, text.id
    assert_equal(
      '<html v="1"><div><span>Get started</span></div></html>',
      text.text
    )
    assert_equal 60, text.style.font_size
  end

  def test_retrieve_table_widget
    mural_id = 'mural-1'
    widget_id = 'table-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return_json(
      body: {
        value: {
          contentEditedBy: {
            firstName: 'Nyan',
            id: 'nyancat-1',
            lastName: 'Cat'
          },
          contentEditedOn: 0,
          createdBy: {
            firstName: 'Nyan',
            id: 'nyancat-1',
            lastName: 'Cat'
          },
          createdOn: 1_757_150_247_262,
          height: 694,
          hidden: false,
          hideEditor: false,
          hideOwner: false,
          id: widget_id,
          instruction: '',
          invisible: false,
          locked: false,
          lockedByFacilitator: false,
          parentId: nil,
          presentationIndex: -1,
          rotation: 0,
          stackingOrder: 0,
          title: '',
          updatedBy: {
            firstName: 'Nyan',
            id: 'nyancat-1',
            lastName: 'Cat'
          },
          updatedOn: 1_757_150_247_262,
          width: 1174,
          x: 504,
          y: -1438,
          autoResize: true,
          columns: [
            {
              columnId: 'col-iccqhqd',
              width: 390
            },
            {
              columnId: 'col-c0fko8e',
              width: 390
            },
            {
              columnId: 'col-yliyaw6',
              width: 390
            }
          ],
          rows: [
            {
              height: 230,
              minHeight: 230,
              rowId: 'row-qn5wtyt'
            },
            {
              height: 230,
              minHeight: 230,
              rowId: 'row-da6l6sp'
            },
            {
              height: 230,
              minHeight: 230,
              rowId: 'row-nk9373l'
            }
          ],
          style: {
            borderColor: '#9E9E9E',
            borderWidth: 3
          },
          type: 'table'
        }
      }
    )

    table = @client.mural_content.retrieve_widget(mural_id, widget_id)

    assert_instance_of Mural::Widget::Table, table
    assert_equal widget_id, table.id
    assert_equal 3, table.columns.size
    assert_instance_of Mural::Widget::Table::Column, table.columns.first
    assert_equal 3, table.rows.size
    assert_instance_of Mural::Widget::Table::Row, table.rows.first
    assert_equal '#9E9E9E', table.style.border_color
  end

  def test_retrieve_table_cell_widget
    mural_id = 'mural-1'
    widget_id = 'table-cell-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return_json(
      body: {
        value: {
          contentEditedBy: {
            firstName: 'James',
            id: 'user-007',
            lastName: 'Bond'
          },
          contentEditedOn: 1_757_150_247_262,
          createdBy: {
            firstName: 'James',
            id: 'user-007',
            lastName: 'Bond'
          },
          createdOn: 1_757_150_247_262,
          height: 230,
          hidden: false,
          hideEditor: false,
          hideOwner: false,
          id: widget_id,
          instruction: '',
          invisible: false,
          locked: false,
          lockedByFacilitator: false,
          parentId: '0-1757150246664',
          presentationIndex: -1,
          rotation: 0,
          stackingOrder: 1,
          title: '',
          updatedBy: {
            firstName: 'James',
            id: 'user-007',
            lastName: 'Bond'
          },
          updatedOn: 1_757_150_247_262,
          width: 390,
          x: 1,
          y: 1,
          colSpan: 1,
          columnId: 'col-iccqhqd',
          rowId: 'row-qn5wtyt',
          rowSpan: 1,
          style: {
            backgroundColor: '#FFFFFFFF'
          },
          textContent: {
            fontFamily: 'proxima-nova',
            fontSize: 23,
            orientation: 'horizontal',
            padding: 36,
            text: '<div><br /></div>',
            textAlign: 'left',
            verticalAlign: 'top'
          },
          type: 'table cell'
        }
      }
    )

    cell = @client.mural_content.retrieve_widget(mural_id, widget_id)

    assert_instance_of Mural::Widget::TableCell, cell
    assert_equal widget_id, cell.id
    assert_equal 'proxima-nova', cell.text_content.font_family
    assert_equal '#FFFFFFFF', cell.style.background_color
  end

  def test_destroy_widget
    mural_id = 'mural-1'
    widget_id = 'widget-1'

    delete_request = stub_request(
      :delete,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/widgets/#{widget_id}"
    ).to_return(status: 204)

    @client.mural_content.destroy_widget(mural_id, widget_id)

    assert_requested delete_request
  end
end
