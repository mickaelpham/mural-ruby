# frozen_string_literal: true

class TestTables < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_create_table_cell_params
    want = %i[
      col_span
      column_id
      height
      rotation
      row_id
      row_span
      style
      text_content
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::CreateTableCellParams.attrs.keys.sort
  end

  def test_create_table_params
    want = %i[
      auto_resize
      cells
      columns
      height
      hidden
      instruction
      parent_id
      presentation_index
      rotation
      rows
      stacking_order
      style
      title
      width
      x
      y
    ]

    assert_equal want, Mural::Widget::CreateTableParams.attrs.keys.sort
  end

  def test_create_table
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/table"
    ).with(
      body: {}
    ).to_return_json(
      body: {
        value: [
          {
            contentEditedBy: {
              firstName: 'Lara',
              id: 'user-1',
              lastName: 'Croft'
            },
            contentEditedOn: 1_757_857_758_121,
            createdBy: {
              firstName: 'Lara',
              id: 'user-1',
              lastName: 'Croft'
            },
            createdOn: 1_757_857_758_121,
            height: 150,
            hidden: false,
            hideEditor: false,
            hideOwner: false,
            id: 'e11ae0a8-7fc3-4e2f-a474-5d56b1b643de',
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
              firstName: 'Lara',
              id: 'user-1',
              lastName: 'Croft'
            },
            updatedOn: 1_757_857_758_121,
            width: 100,
            x: 20,
            y: 148,
            autoResize: true,
            columns: [
              {
                columnId: 'column-1',
                width: 100
              }
            ],
            rows: [
              {
                height: 50,
                minHeight: 30,
                rowId: 'row-1'
              }
            ],
            style: {
              borderColor: 'rgba(250,250,250,1)',
              borderWidth: 5
            },
            type: 'table'
          },
          {
            contentEditedBy: {
              firstName: 'Lara',
              id: 'user-1',
              lastName: 'Croft'
            },
            contentEditedOn: 1_757_857_758_121,
            createdBy: {
              firstName: 'Lara',
              id: 'user-1',
              lastName: 'Croft'
            },
            createdOn: 1_757_857_758_121,
            height: 150,
            hidden: false,
            hideEditor: false,
            hideOwner: false,
            id: '26c3b066-fd09-4a6e-9e4d-d5072c875f6e',
            instruction: '',
            invisible: false,
            locked: false,
            lockedByFacilitator: false,
            parentId: 'e11ae0a8-7fc3-4e2f-a474-5d56b1b643de',
            presentationIndex: -1,
            rotation: 0,
            stackingOrder: 0,
            title: '',
            updatedBy: {
              firstName: 'Lara',
              id: 'user-1',
              lastName: 'Croft'
            },
            updatedOn: 1_757_857_758_121,
            width: 140,
            x: 0,
            y: 0,
            colSpan: 1,
            columnId: 'column-1',
            rowId: 'row-1',
            rowSpan: 1,
            style: {
              backgroundColor: '#FFFFFFFF'
            },
            textContent: {
              fontFamily: 'proxima-nova',
              fontSize: 24,
              orientation: 'horizontal',
              padding: 23,
              text: 'Hello',
              textAlign: 'center',
              verticalAlign: 'middle'
            },
            type: 'table cell'
          }
        ]
      },
      status: 201
    )

    params = Mural::Widget::CreateTableParams.new.tap do |table| # rubocop:disable Metrics/BlockLength
      table.cells = [
        Mural::Widget::CreateTableCellParams.new.tap do |cell|
          cell.text_content =
            Mural::Widget::CreateTableCellParams::TextContent.new.tap do |text_content|
              text_content.text = 'Hello'
              text_content.font_family = 'proxima-nova'
              text_content.orientation = 'horizontal'
              text_content.text_align = 'center'
              text_content.vertical_align = 'middle'
              text_content.font_size = 24
              text_content.padding = 23
            end

          cell.column_id = 'column-1'
          cell.col_span = 1
          cell.height = 150
          cell.width = 140
          cell.x = 0
          cell.y = 0
          cell.row_id = 'row-1'
          cell.row_span = 1
        end
      ]

      table.columns = [
        Mural::Widget::CreateTableParams::Column.new.tap do |col|
          col.width = 100
          col.column_id = 'column-1'
        end
      ]

      table.rows = [
        Mural::Widget::CreateTableParams::Row.new.tap do |row|
          row.height = 50
          row.min_height = 30
          row.row_id = 'row-1'
        end
      ]

      table.style = Mural::Widget::CreateTableParams::Style.new.tap do |style|
        style.border_color = '#FAFAFAFF'
        style.border_width = 5
      end

      table.width = 100
      table.height = 150
      table.x = 20
      table.y = 148
    end

    widgets = @client.mural_content.create_table(mural_id, params)

    assert_equal 2, widgets.size
  end

  def test_create_table_with_empty_cell
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/table"
    ).with(
      body: {}
    ).to_return_json(
      body: {
        value: [
          {
            contentEditedBy: {
              firstName: 'Nathan',
              id: 'user-2',
              lastName: 'West'
            },
            contentEditedOn: 1_757_858_678_513,
            createdBy: {
              firstName: 'Nathan',
              id: 'user-2',
              lastName: 'West'
            },
            createdOn: 1_757_858_678_513,
            height: 150,
            hidden: false,
            hideEditor: false,
            hideOwner: false,
            id: 'da059257-5fc6-4b92-8a54-c8e6f98b554f',
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
              firstName: 'Nathan',
              id: 'user-2',
              lastName: 'West'
            },
            updatedOn: 1_757_858_678_513,
            width: 100,
            x: 20,
            y: 148,
            autoResize: true,
            columns: [
              {
                columnId: 'column-1',
                width: 100
              }
            ],
            rows: [
              {
                height: 50,
                minHeight: 30,
                rowId: 'row-1'
              }
            ],
            style: {
              borderColor: '#9E9E9E',
              borderWidth: 3
            },
            type: 'table'
          },
          {
            contentEditedBy: {
              firstName: 'Nathan',
              id: 'user-2',
              lastName: 'West'
            },
            contentEditedOn: 1_757_858_678_513,
            createdBy: {
              firstName: 'Nathan',
              id: 'user-2',
              lastName: 'West'
            },
            createdOn: 1_757_858_678_513,
            height: 150,
            hidden: false,
            hideEditor: false,
            hideOwner: false,
            id: 'f49a96c7-c2a5-435b-bed6-4415312445b6',
            instruction: '',
            invisible: false,
            locked: false,
            lockedByFacilitator: false,
            parentId: 'da059257-5fc6-4b92-8a54-c8e6f98b554f',
            presentationIndex: -1,
            rotation: 0,
            stackingOrder: 0,
            title: '',
            updatedBy: {
              firstName: 'Nathan',
              id: 'user-2',
              lastName: 'West'
            },
            updatedOn: 1_757_858_678_513,
            width: 140,
            x: 0,
            y: 0,
            colSpan: 1,
            columnId: 'column-1',
            rowId: 'row-1',
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
        ]
      },
      status: 201
    )

    params = Mural::Widget::CreateTableParams.new.tap do |table| # rubocop:disable Metrics/BlockLength
      table.cells = [
        Mural::Widget::CreateTableCellParams.new.tap do |cell|
          cell.column_id = 'column-1'
          cell.col_span = 1
          cell.height = 150
          cell.width = 140
          cell.x = 0
          cell.y = 0
          cell.row_id = 'row-1'
          cell.row_span = 1

          cell.style =
            Mural::Widget::CreateTableCellParams::Style.new.tap do |style|
              style.background_color = '#FFFFFFFF'
            end
        end
      ]

      table.columns = [
        Mural::Widget::CreateTableParams::Column.new.tap do |col|
          col.width = 100
          col.column_id = 'column-1'
        end
      ]

      table.rows = [
        Mural::Widget::CreateTableParams::Row.new.tap do |row|
          row.height = 50
          row.min_height = 30
          row.row_id = 'row-1'
        end
      ]

      table.style = Mural::Widget::CreateTableParams::Style.new.tap do |style|
        style.border_color = '#FAFAFAFF'
        style.border_width = 5
      end

      table.width = 100
      table.height = 150
      table.x = 20
      table.y = 148
    end

    widgets = @client.mural_content.create_table(mural_id, params)

    assert_equal 2, widgets.size
  end

  def test_create_empty_table
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/widgets/table"
    ).with(
      body: {
        width: 100,
        height: 150,
        x: 20,
        y: 148
      }
    ).to_return_json(
      body: {
        code: 'BODY',
        details: [
          {
            code: 'Invalid property',
            message: 'Invalid "cells" property type was sent. ' \
                     'Type array was expected.'
          },
          {
            code: 'Invalid property',
            message: 'Invalid "columns" property type was sent. ' \
                     'Type array was expected.'
          },
          {
            code: 'Invalid property',
            message: 'Invalid "rows" property type was sent. ' \
                     'Type array was expected.'
          }
        ],
        message: 'Invalid payload'
      },
      status: 400
    )

    params = Mural::Widget::CreateTableParams.new.tap do |table|
      table.width = 100
      table.height = 150
      table.x = 20
      table.y = 148
    end

    assert_raises(Mural::Error) do
      @client.mural_content.create_table(mural_id, params)
    end
  end
end
