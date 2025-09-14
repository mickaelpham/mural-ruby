# frozen_string_literal: true

module Mural
  class Widget
    class CreateTableCellParams
      include Mural::Codec

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

      def encode
        super.tap do |json|
          json['style'] = json['style']&.encode
          json['textContent'] = json['textContent']&.encode
        end.compact
      end

      Style = Mural::Widget::TableCell::Style
      TextContent = Mural::Widget::TableCell::TextContent
    end
  end
end
