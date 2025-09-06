# frozen_string_literal: true

module Mural
  class Widget
    class Shape
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        # The text in the widget. It supports inline formatting using HTML tags.
        html_text: 'htmlText',

        # The type of shape of the shape widget.
        shape: 'shape',

        # Style properties of the widget.
        style: 'style',

        # The text in the widget.
        text: 'text',

        # The title of the widget in the outline.
        title: 'title'
      )

      def self.decode(json)
        super.tap do |shape|
          shape.style = Style.decode(shape.style)
        end
      end

      class Style
        include Mural::Codec

        define_attributes(
          # The background color of the widget in hex with alpha format.
          background_color: 'backgroundColor',

          # The border color of the widget in hex with alpha format.
          border_color: 'borderColor',

          # The border style of the widget.
          # ["solid", "dotted"]
          border_style: 'borderStyle',

          # The border width of the widget.
          # 1 to 7
          border_width: 'borderWidth',

          # If true, text is bold.
          bold: 'bold',

          # If true, text is italic.
          italic: 'italic',

          # If true, text is underlined.
          underline: 'underline',

          # If true, text is striked.
          strike: 'strike',

          # Font-family of the text.
          font: 'font',

          # The font color of the widget in hex with alpha format.
          font_color: 'fontColor',

          # Text size.
          font_size: 'fontSize',

          # The alignment of the text.
          # ["left", "center", "right"]
          text_align: 'textAlign'
        )
      end
    end
  end
end
