# frozen_string_literal: true

module Mural
  class Widget
    class Table
      include Mural::Codec

      # https://developers.mural.co/public/reference/createtable
      define_attributes(
        **Mural::Widget.attrs,

        # If true, the widget will automatically resize to fit its content.
        auto_resize: 'autoResize',

        # The title of the widget in the outline.
        title: 'title',

        # The array of columns definition.
        columns: 'columns',

        # The array of rows definition.
        rows: 'rows',

        # Style properties of the widget.
        style: 'style'
      )

      def self.decode(json)
        super.tap do |table|
          table.columns&.map! { |col| Column.decode(col) }
          table.rows&.map! { |row| Row.decode(row) }
          table.style = Style.decode(table.style)
        end
      end

      class Column
        include Mural::Codec

        define_attributes(
          # The ID of the column.
          column_id: 'columnId',

          # The width of the column.
          width: 'width'
        )
      end

      class Row
        include Mural::Codec

        define_attributes(
          # The height of the row.
          height: 'height',

          # The min height of the row.
          min_height: 'minHeight',

          # The ID of the row.
          row_id: 'rowId'
        )
      end

      class Style
        include Mural::Codec

        define_attributes(
          # The border color of the widget in hex with alpha format.
          border_color: 'borderColor',

          # The border width
          border_width: 'borderWidth'
        )
      end
    end
  end
end
