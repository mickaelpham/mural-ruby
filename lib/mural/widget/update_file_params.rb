# frozen_string_literal: true

module Mural
  class Widget
    class UpdateFileParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/updatefile
      define_attributes(
        **Mural::Widget::CreateFileParams.attrs.reject do |attr|
          %i[name stacking_order].include? attr
        end
      )
    end
  end
end
