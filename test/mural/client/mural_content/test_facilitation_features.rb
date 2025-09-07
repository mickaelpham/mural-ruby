# frozen_string_literal: true

class TestFacilitationFeatures < Minitest::Test
  def setup
    @client = Mural::Client.new
  end

  def test_start_private_mode
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/private-mode/start"
    )
      .with(body: { hideAuthors: true })
      .to_return_json(
        body: {
          value: {
            active: true,
            initialTimestamp: 1,
            startedBy: 'user-1',
            hideAuthors: true
          }
        }
      )

    private_mode =
      @client.mural_content.start_private_mode(mural_id, hide_authors: true)

    assert_instance_of Mural::PrivateMode, private_mode
    assert_equal 'user-1', private_mode.started_by
    assert private_mode.hide_authors
  end

  def test_stop_private_mode
    mural_id = 'mural-1'

    stop_request = stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/private-mode/stop"
    ).to_return(status: 204)

    @client.mural_content.stop_private_mode(mural_id)

    assert_requested stop_request
  end

  def test_retrieve_private_mode
    mural_id = 'mural-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/private-mode"
    ).to_return_json(body: { value: { active: false } })

    private_mode = @client.mural_content.retrieve_private_mode(mural_id)

    refute private_mode.active
  end

  def test_list_voting_sessions
    mural_id = 'mural-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/voting-sessions"
    ).to_return_json(
      body: {
        value: [
          {
            id: 'voting-session-1',
            title: 'My voting session'
          }
        ]
      }
    )

    voting_sessions, = @client.mural_content.list_voting_sessions(mural_id)

    assert_equal 1, voting_sessions.size

    voting_session = voting_sessions.first

    assert_instance_of Mural::VotingSession, voting_session
    assert_equal 'voting-session-1', voting_session.id
    assert_equal 'My voting session', voting_session.title
  end

  def test_retrieve_voting_session
    mural_id = 'mural-1'
    voting_session_id = 'voting-session-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/voting-sessions/#{voting_session_id}"
    ).to_return_json(
      body: {
        value: {
          id: 'voting-session-1',
          title: 'My voting session'
        }

      }
    )

    voting_session =
      @client
      .mural_content
      .retrieve_voting_session(mural_id, voting_session_id)

    assert_instance_of Mural::VotingSession, voting_session
    assert_equal 'voting-session-1', voting_session.id
    assert_equal 'My voting session', voting_session.title
  end

  def test_destroy_voting_session
    mural_id = 'mural-1'
    voting_session_id = 'voting-session-1'

    delete_request = stub_request(
      :delete,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/voting-sessions/#{voting_session_id}"
    ).to_return(status: 204)

    @client.mural_content.destroy_voting_session(mural_id, voting_session_id)

    assert_requested delete_request
  end
end
