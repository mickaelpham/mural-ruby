# frozen_string_literal: true

module Mural
  class Widget
    class CreateArrowParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/createarrow
      define_attributes(
        **Mural::Widget::Arrow.attrs.reject do |attr|
          %i[
            content_edited_by
            content_edited_on
            created_by
            created_on
            hidden
            hide_editor
            hide_owner
            id
            invisible
            locked
            locked_by_facilitator
            type
            updated_by
            updated_on
          ].include? attr
        end
      )

      def encode
        super.tap do |json|
          json['points']&.map!(&:encode)
          json['label'] = json['label']&.encode
          json['style'] = json['style']&.encode
        end
      end

      Style = Mural::Widget::Arrow::Style
      Label = Mural::Widget::Arrow::Label
      Point = Mural::Widget::Arrow::Point
    end
  end
end
