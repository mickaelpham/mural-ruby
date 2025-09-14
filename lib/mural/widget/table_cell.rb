# frozen_string_literal: true

module Mural
  class Widget
    class TableCell
      include Mural::Codec

      # # https://developers.mural.co/public/reference/createtable
      define_attributes(
        **Mural::Widget.attrs,

        # Number of columns a cell can span.
        col_span: 'colSpan',

        # The ID of the column.
        column_id: 'columnId',

        # The ID of the row.
        row_id: 'rowId',

        # Number of rows a cell can span.
        row_span: 'rowSpan',

        # Style properties of the widget.
        style: 'style',

        # textContent properties of the widget.
        text_content: 'textContent',

        # The title of the widget in the outline.
        title: 'title'
      )

      def self.decode(json)
        super.tap do |cell|
          cell.style = Style.decode(cell.style)
          cell.text_content = TextContent.decode(cell.text_content)
        end
      end

      class Style
        include Mural::Codec

        # The backgroud color of the cell in hex with alpha format.
        define_attributes(background_color: 'backgroundColor')
      end

      class TextContent
        include Mural::Codec

        define_attributes(
          # Font-family of the text.
          font_family: 'fontFamily',

          # Text size.
          font_size: 'fontSize',

          # The orientation of the text content.
          # ["horizontal", "vertical-left", "vertical-right"]
          orientation: 'orientation',

          # Padding of the text content.
          padding: 'padding',

          # The text in the widget. It supports inline formatting using HTML
          # tags.
          text: 'text',

          # The alignment of the text.
          # ["left", "center", "right"]
          text_align: 'textAlign',

          # The vertical alignment of the text.
          # ["top", "middle", "bottom"]
          vertical_align: 'verticalAlign'
        )
      end
    end
  end
end
