# frozen_string_literal: true

module Mural
  class Widget
    class StickyNote
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        # The text in the widget. It supports inline formatting using HTML tags.
        html_text: 'htmlText',

        # The shape of the sticky note widget.
        # ["circle", "rectangle"]
        shape: 'shape',

        # Style properties of the widget.
        style: 'style',

        # The text in the widget.
        text: 'text',

        # The URL used in the widget.
        hyperlink: 'hyperlink',

        # Text displayed on the hyperlink button.
        hyperlink_title: 'hyperlinkTitle',

        # The minimum number of lines in the sticky note widget.
        min_lines: 'minLines',

        # Unique identifiers of the tags in the widget.
        tags: 'tags',

        # The title of the widget in the outline.
        title: 'title'
      )

      def self.decode(json)
        super.tap do |sticky_note|
          sticky_note.style = Style.decode(sticky_note.style)
        end
      end

      class Style
        include Mural::Codec

        define_attributes(
          # The background color of the widget in hex with alpha format.
          background_color: 'backgroundColor',

          # If true, text is bold.
          bold: 'bold',

          # If true, a black border is displayed around the widget.
          border: 'border',

          # If true, text is italic.
          italic: 'italic',

          # If true, text is underlined.
          underline: 'underline',

          # If true, text is striked.
          strike: 'strike',

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
