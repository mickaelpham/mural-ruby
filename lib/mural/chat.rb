# frozen_string_literal: true

module Mural
  class Chat
    include Mural::Codec

    # https://developers.mural.co/public/reference/getmuralchat
    define_attributes(
      # The ID of the chat message.
      id: 'id',
      # The content of the chat message.
      message: 'message',
      # The timestamp of the chat message.
      created_on: 'createdOn',
      # The user object
      user: 'user'
    )

    def self.decode(json)
      super.tap do |chat|
        chat.user = User.decode(chat.user)
      end
    end

    class User
      include Mural::Codec

      define_attributes(
        # First name of the member or guest in the chat.
        first_name: 'firstName',
        # Last name of the member or guest in the chat.
        last_name: 'lastName',
        # ID of a user.
        id: 'id'
      )
    end
  end
end
