# frozen_string_literal: true

module Mural
  class Widget
    class CreateAreaParams
      include Mural::Codec

      define_attributes(
        **Mural::Widget::Area.attrs.reject do |attr|
          %i[
            content_edited_by
            content_edited_on
            created_by
            created_on
            hide_editor
            hide_owner
            id
            invisible
            locked
            locked_by_facilitator
            rotation
            type
            updated_by
            updated_on
          ].include? attr
        end
      )

      Style = Mural::Widget::Area::Style

      def encode
        super.tap do |json|
          json['style'] = json['style']&.encode
        end
      end
    end
  end
end
