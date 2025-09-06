# frozen_string_literal: true

module Mural
  class Widget
    include Mural::Codec

    SPECIALIZED = {
      'area' => 'Mural::Widget::Area',
      'arrow' => 'Mural::Widget::Arrow',
      'comment' => 'Mural::Widget::Comment',
      'file' => 'Mural::Widget::File',
      'icon' => 'Mural::Widget::Icon',
      'image' => 'Mural::Widget::Image',
      'shape' => 'Mural::Widget::Shape',
      'sticky note' => 'Mural::Widget::StickyNote',
      'table cell' => 'Mural::Widget::TableCell',
      'table' => 'Mural::Widget::Table',
      'text' => 'Mural::Widget::Text'
    }.freeze

    define_attributes(
      # The unique ID of the widget.
      id: 'id',

      # The height of the widget in px.
      height: 'height',

      # The width of the widget in px.
      width: 'width',

      # The horizontal position of the widget in px. This is the distance from
      # the left of the parent widget, such as an area. If the widget has no
      # parent widget, this is the distance from the left of the mural.
      x: 'x',

      # The vertical position of the widget in px. This is the distance from
      # the top of the parent widget, such as an area. If the widget has no
      # parent widget, this is the distance from the top of the mural.
      y: 'y',

      # Indicates whether the widget is invisible, defaults to `false`.
      invisible: 'invisible',

      # Timestamp in milliseconds.
      content_edited_on: 'contentEditedOn',

      # The collaborator who last edited content on the widget.
      content_edited_by: 'contentEditedBy',

      # Timestamp in milliseconds.
      created_on: 'createdOn',

      # The collaborator who created the widget.
      created_by: 'createdBy',

      # Timestamp in milliseconds.
      updated_on: 'updatedOn',

      # The collaborator who last updated the widget.
      updated_by: 'updatedBy',

      # The angle of widget rotation, in degrees.
      rotation: 'rotation',

      # The z-index stacking order of the widget.
      stacking_order: 'stackingOrder',

      # If true, the widget is hidden from non-facilitators. Applies only when
      # the widget is in the outline.
      hidden: 'hidden',

      # If true, the name of the collaborator who updated the widget is not
      # recorded (because Private Mode is enabled).
      hide_editor: 'hideEditor',

      # If true, the name of the collaborator who created the widget is not
      # recorded (because Private Mode is enabled).
      hide_owner: 'hideOwner',

      # The instructions for a section of the outline. This text can only be
      # added and modified by a facilitator.
      instruction: 'instruction',

      # If true, the widget is locked and cannot be updated by a
      # non-facilitator. Any collaborator can unlock a locked widget.
      locked: 'locked',

      # If true, the widget is locked by a facilitator. Only a facilitator can
      # unlock it.
      locked_by_facilitator: 'lockedByFacilitator',

      # The ID of the area widget that contains the widget.
      parent_id: 'parentId',

      # The list order of the widget in the outline.
      presentation_index: 'presentationIndex',

      # The type of the widget (`file`).
      type: 'type'
    )

    def self.decode(json)
      specialized = SPECIALIZED[json['type']]
      widget = specialized ? Object.const_get(specialized).decode(json) : super

      widget.tap do |f|
        f.content_edited_by = ContentEditedBy.decode(f.content_edited_by)
        f.created_by = CreatedBy.decode(f.created_by)
        f.updated_by = UpdatedBy.decode(f.updated_by)
      end
    end

    class ContentEditedBy
      include Mural::Codec

      define_attributes(
        id: 'id',

        # when edited by a member
        first_name: 'firstName',
        last_name: 'lastName',

        # when edited by a visitor
        alias: 'alias'
      )
    end

    class CreatedBy
      include Mural::Codec

      define_attributes(
        id: 'id',

        # when edited by a member
        first_name: 'firstName',
        last_name: 'lastName',

        # when edited by a visitor
        alias: 'alias'
      )
    end

    class UpdatedBy
      include Mural::Codec

      define_attributes(
        id: 'id',

        # when edited by a member
        first_name: 'firstName',
        last_name: 'lastName',

        # when edited by a visitor
        alias: 'alias'
      )
    end
  end
end
