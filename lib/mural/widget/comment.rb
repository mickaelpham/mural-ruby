# frozen_string_literal: true

module Mural
  class Widget
    class Comment
      include Mural::Codec

      define_attributes(
        **Mural::Widget.attrs,

        # The message text of the comment widget.
        message: 'message',

        # Array of replies
        replies: 'replies',

        # The timestamp for the creation of the comment in milliseconds.
        timestamp: 'timestamp',

        # The reference ID of the widget that the comment points to.
        reference_widget_id: 'referenceWidgetId',

        # The collaborator who resolved the comment.
        resolved_by: 'resolvedBy',

        # The timestamp when the comment was resolved, in milliseconds.
        resolved_on: 'resolvedOn',

        # The title of the widget in the outline.
        title: 'title'
      )

      def self.decode(json)
        super.tap do |comment|
          comment.replies = comment.replies&.map { |r| Reply.decode(r) }
          comment.resolved_by = ResolvedBy.decode(comment.resolved_by)
        end
      end

      class ResolvedBy
        include Mural::Codec

        define_attributes(
          # ID of a user.
          id: 'id',

          # When the user is a member
          first_name: 'firstName',
          last_name: 'lastName',

          # When the user is a visitor
          alias: 'alias'
        )
      end

      class Reply
        include Mural::Codec

        define_attributes(
          # The timestamp of the reply in milliseconds.
          created: 'created',

          # The text of the reply.
          message: 'message',
          user: 'user'
        )

        def self.decode(json)
          super.tap do |reply|
            reply.user = User.decode(reply.user)
          end
        end

        class User
          include Mural::Codec

          define_attributes(
            # ID of a user.
            id: 'id',

            # When the user is a member
            first_name: 'firstName',
            last_name: 'lastName',

            # When the user is a visitor
            alias: 'alias'
          )
        end
      end
    end
  end
end
