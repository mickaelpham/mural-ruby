# frozen_string_literal: true

module Mural
  class Widget
    class UpdateImageParams
      include Mural::Codec

      define_attributes(
        **Mural::Widget::CreateImageParams.attrs.reject do |attr|
          %i[name].include? attr
        end
      )
    end
  end
end
