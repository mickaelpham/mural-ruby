# frozen_string_literal: true

module Mural
  class Widget
    class CreateTableCellParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/createtable
      define_attributes(
        **Mural::Widget::TableCell.attrs.filter do |attr|
          %i[
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
          ].include? attr
        end
      )

      Style = Mural::Widget::TableCell::Style
      TextContent = Mural::Widget::TableCell::TextContent

      def encode
        super.tap do |json|
          json['style'] = json['style']&.encode
          json['textContent'] = json['textContent']&.encode
        end.compact
      end
    end
  end
end
