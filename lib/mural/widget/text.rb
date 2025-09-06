# frozen_string_literal: true

module Mural
  class Widget
    class Text
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        # Style properties of the widget.
        style: 'style',

        # The text in the widget.
        text: 'text',

        # The URL used in the widget.
        hyperlink: 'hyperlink',

        # Text displayed on the hyperlink button.
        hyperlinkTitle: 'hyperlinkTitle',

        # When true, the text wraps to fit the widget. When false, the widget
        # grows to fit the text. True when widget is created as a textbox and
        # false when widget is created as a title.
        fixed_width: 'fixedWidth',

        # The title of the widget in the outline.
        title: 'title'
      )

      def self.decode(json)
        super.tap do |text|
          text.style = Style.decode(text.style)
        end
      end

      class Style
        include Mural::Codec

        define_attributes(
          # The background color of the widget in hex with alpha format.
          background_color: 'backgroundColor',

          # Font-family of the text.
          font: 'font',

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
