# frozen_string_literal: true

module Mural
  class Widget
    # UNDOCUMENTED
    # This widget is not documented within Mural public API documentation.
    class Table
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        title: 'title',
        auto_resize: 'autoResize',
        columns: 'columns',
        rows: 'rows',
        style: 'style'
      )

      def self.decode(json)
        super.tap do |table|
          table.columns = table.columns&.map { |col| Column.decode(col) }
          table.rows = table.rows&.map { |row| Row.decode(row) }
          table.style = Style.decode(table.style)
        end
      end

      class Column
        include Mural::Codec

        define_attributes(column_id: 'columnId', width: 'width')
      end

      class Row
        include Mural::Codec

        define_attributes(
          height: 'height',
          min_height: 'minHeight',
          row_id: 'row_id'
        )
      end

      class Style
        include Mural::Codec

        define_attributes(
          border_color: 'borderColor',
          border_width: 'borderWidth'
        )
      end
    end
  end
end
