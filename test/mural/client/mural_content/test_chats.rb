# frozen_string_literal: true

class TestChats < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_list_chats
    mural_id = 'mural-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/chat"
    ).to_return_json(
      body: {
        value: [
          {
            id: 'chat-1',
            message: 'Hello, world!',
            createdOn: 1,
            user: {
              firstName: 'Lara',
              lastName: 'Croft',
              id: 'user-1'
            }
          }
        ]
      }
    )

    chats, = @client.mural_content.list_chats(mural_id)

    assert_equal 1, chats.size

    chat = chats.first

    assert_instance_of Mural::Chat, chat
    assert_equal 'chat-1', chat.id
    assert_equal 'Lara', chat.user.first_name
  end
end
