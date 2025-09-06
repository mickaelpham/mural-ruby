# frozen_string_literal: true

module Mural
  class Widget
    class UpdateFileParams
      include Mural::Codec

      # https://developers.mural.co/public/reference/updatefile
      define_attributes(
        # The height of the widget in px. This value will be overwritten if the
        # file has a preview from which the final value will be extracted.
        height: 'height',

        # If true, the widget is hidden from non-facilitators. Applies only when
        # the widget is in the outline.
        hidden: 'hidden',

        # The instructions for a section of the outline. This text can only be
        # added and modified by a facilitator.
        instruction: 'instruction',

        # The ID of the area widget that contains the widget.
        parent_id: 'parentId',

        # The list order of the widget in the outline.
        presentation_index: 'presentationIndex',

        # The angle of widget rotation in degrees.
        rotation: 'rotation',

        # The title in the file widget and in the outline.
        title: 'title',

        # The width of the widget in px. This value will be overwritten if the
        # file has a preview from which the final value will be extracted.
        width: 'width',

        # The horizontal position of the widget in px. This is the distance from
        # the left of the parent widget, such as an area. If the widget has no
        # parent widget, this is the distance from the left of the mural.
        x: 'x',

        # The vertical position of the widget in px. This is the distance from
        # the top of the parent widget, such as an area. If the widget has no
        # parent widget, this is the distance from the top of the mural.
        y: 'y'
      )
    end
  end
end
