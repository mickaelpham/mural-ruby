# frozen_string_literal: true

module Mural
  class Widget
    class Arrow
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        # The type of the arrow line.
        # ["straight", "curved", "orthogonal"]
        arrow_type: 'arrowType',

        # The type of the arrow tip.
        # ["no tip", "single", "double"]
        tip: 'tip',

        # If true, the widget is stackable.
        stackable: 'stackable',

        # Array of objects
        points: 'points',

        # Style properties of the widget.
        style: 'style',

        # The ID of the widget that the start point is connected to.
        start_ref_id: 'startRefId',

        # The ID of the widget that the end point is connected to.
        end_ref_id: 'endRefId',

        # label
        label: 'label',

        # The title of the widget in the outline.
        title: 'title'
      )

      def self.decode(json)
        super.tap do |arrow|
          arrow.points = arrow.points&.map { |point| Point.decode(point) }
          arrow.style = Style.decode(arrow.style)

          # Making sure I'm calling the "right" Label class
          arrow.label = Mural::Widget::Arrow::Label.decode(arrow.label)
        end
      end

      class Point
        include Mural::Codec

        define_attributes(x: 'x', y: 'y')
      end

      class Style
        include Mural::Codec

        define_attributes(
          # The stroke color of the connector in hex with alpha format.
          stroke_color: 'strokeColor',

          # The stroke style of the connector.
          # ["solid", "dashed", "dotted-spaced", "dotted"]
          stroke_style: 'strokeStyle',

          # The stroke width of the connector.
          stroke_width: 'strokeWidth'
        )
      end

      class Label
        include Mural::Codec

        define_attributes(format: 'format', labels: 'labels')

        def self.decode(json)
          super.tap do |label|
            next if label.nil?

            label.labels = label.labels.map do |l|
              # I'm not responsible for this naming…
              Mural::Widget::Arrow::Label::Label.decode(l)
            end

            label.format = Format.decode(label.format)
          end
        end

        def encode
          super.tap do |json|
            json['format'] = json['format']&.encode
            json['labels']&.map!(&:encode)
          end.compact
        end

        class Format
          include Mural::Codec

          define_attributes(
            # color
            color: 'color',

            # Font-family of the text.
            font_family: 'fontFamily',

            # If true, the text of the label on the connector is bold.
            bold: 'bold',

            # If true, the text of the label on the connector is italic.
            italic: 'italic',

            # The alignment of the text of the label on the connector.
            # ["left", "center", "right"]
            text_align: 'textAlign',

            # The font size of the text of the label on the connector.
            font_size: 'fontSize'
          )
        end

        class Label
          include Mural::Codec

          define_attributes(
            # The horizontal position of the label on the connector in px.
            x: 'x',

            # The vertical position of the label on the connector in px.
            y: 'y',

            # The height of the label on the connector in px.
            height: 'height',

            # The width of the label on the connector in px.
            width: 'width',

            # The text of the label on the connector.
            text: 'text'
          )
        end
      end
    end
  end
end
