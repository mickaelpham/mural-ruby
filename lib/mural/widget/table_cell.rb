# frozen_string_literal: true

module Mural
  class Widget
    # UNDOCUMENTED
    # This widget is not documented within Mural public API documentation.
    class TableCell
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        title: 'title',
        col_span: 'colSpan',
        column_id: 'columnId',
        row_id: 'rolId',
        row_span: 'rowSpan',
        style: 'style',
        text_content: 'textContent'
      )

      def self.decode(json)
        super.tap do |cell|
          cell.style = Style.decode(cell.style)
          cell.text_content = TextContent.decode(cell.text_content)
        end
      end

      class Style
        include Mural::Codec

        define_attributes(background_color: 'backgroundColor')
      end

      class TextContent
        include Mural::Codec

        define_attributes(
          font_family: 'fontFamily',
          font_size: 'fontSize',
          orientation: 'orientation',
          padding: 'padding',
          text: 'text',
          text_align: 'textAlign',
          vertical_align: 'verticalAlign'
        )
      end
    end
  end
end
