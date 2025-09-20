# frozen_string_literal: true

module Mural
  class Widget
    class CreateCommentParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/createcomment
      define_attributes(
        **Mural::Widget::Comment.attrs.filter do |attr|
          %i[
            message
            reference_widget_id
            stacking_order
            x
            y
          ].include? attr
        end,

        # If true, the comment is marked as resolved.
        resolved: 'resolved'
      )
    end
  end
end
