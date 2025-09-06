# frozen_string_literal: true

module Mural
  class Widget
    class Icon
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        # The name of the icon.
        name: 'name',

        # Style properties of the widget.
        style: 'style',

        # The title of the widget in the outline.
        title: 'title'
      )

      def self.decode(json)
        super.tap do |icon|
          icon.style = Style.decode(icon.style)
        end
      end

      class Style
        include Mural::Codec

        define_attributes(color: 'color')
      end
    end
  end
end
