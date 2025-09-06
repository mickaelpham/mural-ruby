# frozen_string_literal: true

module Mural
  class Widget
    class Area
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        # Style properties of the widget.
        style: 'style',

        # The area layout type.
        layout: 'layout',

        # If true, the title is displayed.
        show_title: 'showTitle',

        # The title in the area widget and in the outline.
        title: 'title'
      )

      def self.decode(json)
        super.tap do |area|
          area.style = Style.decode(area.style)
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
          # ["solid", "dashed", "dotted-spaced", "dotted"]
          border_style: 'borderStyle',

          # The border width of the widget.
          border_width: 'borderWidth',

          # The font size of the title of the widget.
          title_font_size: 'titleFontSize'
        )
      end
    end
  end
end
