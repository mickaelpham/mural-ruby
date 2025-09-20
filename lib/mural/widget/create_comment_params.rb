# frozen_string_literal: true

module Mural
  class Widget
    class CreateCommentParams
      include Mural::Codec

      define_attributes(
        **Mural::Widget::Comment.attrs.filter do |attr|
          %i[
            reference_widget_id
            message
            stacking_order
            x
            y
          ].include? attr
        end,

        resolved: 'resolved'
      )
    end
  end
end
