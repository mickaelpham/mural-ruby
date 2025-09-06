# frozen_string_literal: true

module Mural
  class CreateStickyNoteParams
    include Mural::Codec

    define_attributes(
      **Mural::Widget::StickyNote.attrs.reject do |attr|
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
          min_lines
          type
          updated_by
          updated_on
        ].include?(attr)
      end
    )

    def encode
      super.tap do |json|
        json['style'] = json['style']&.encode
      end.compact
    end

    # Exact same values, no restrictions
    Style = Mural::Widget::StickyNote::Style
  end
end
