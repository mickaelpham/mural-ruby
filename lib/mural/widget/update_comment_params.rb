# frozen_string_literal: true

module Mural
  class Widget
    class UpdateCommentParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/updatecomment
      define_attributes(
        **Mural::Widget::CreateCommentParams.attrs.reject do |attr|
          %i[stacking_order].include? attr
        end,

        replies: 'replies'
      )
    end
  end
end
