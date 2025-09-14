# frozen_string_literal: true

module Mural
  class Widget
    class CreateTableParams
      include Mural::Codec

      define_attributes(
        **Mural::Widget::Table.attrs.filter do |attr|
          %i[
            auto_resize
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
          ].include? attr
        end,

        # The array of table cells.
        cells: 'cells'
      )

      Row = Mural::Widget::Table::Row
      Column = Mural::Widget::Table::Column
      Style = Mural::Widget::Table::Style

      def encode # rubocop:disable Metrics/CyclomaticComplexity
        super.tap do |json|
          json['cells']&.map!(&:encode)
          json['rows']&.map!(&:encode)
          json['columns']&.map!(&:encode)
          json['style'] = json['style']&.encode
        end.compact
      end
    end
  end
end
