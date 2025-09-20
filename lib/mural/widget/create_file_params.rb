# frozen_string_literal: true

module Mural
  class Widget
    class CreateFileParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/createfile
      define_attributes(
        **Mural::Widget::File.attrs.filter do |attr|
          %i[
            height
            hidden
            instruction
            parent_id
            presentation_index
            rotation
            stacking_order
            title
            width
            x
            y
          ].include? attr
        end,

        # The name of the file.
        name: 'name'
      )
    end
  end
end
