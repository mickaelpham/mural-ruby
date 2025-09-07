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

  def test_end_private_mode
    mural_id = 'mural-1'

    end_private_mode_request = stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/private-mode/end"
    ).to_return(status: 204)

    @client.mural_content.end_private_mode(mural_id)

    assert_requested end_private_mode_request
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

  def test_start_voting_session
    mural_id = 'mural-1'
    title = 'Voting time!'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      '/voting-sessions/start'
    ).with(
      body: { title: title, numberOfVotes: 2, widgetTypes: ['sticky notes'] }
    ).to_return_json(body: { value: { id: 'voting-session-1', title: title } })

    start_voting_session_params =
      Mural::StartVotingSessionParams.new.tap do |params|
        params.title = title
        params.number_of_votes = 2
        params.widget_types = ['sticky notes']
      end

    voting_session = @client.mural_content.start_voting_session(
      mural_id,
      start_voting_session_params
    )

    assert_instance_of Mural::VotingSession, voting_session
    assert_equal 'voting-session-1', voting_session.id
    assert_equal title, voting_session.title
  end

  def test_start_voting_session_in_area
    mural_id = 'mural-1'
    title = 'Voting time!'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      '/voting-sessions/start'
    ).with(
      body: {
        title: title,
        numberOfVotes: 2,
        widgetTypes: ['sticky notes'],
        area: { top: 10, left: 100, width: 200, height: 200 }
      }
    ).to_return_json(body: { value: { id: 'voting-session-1', title: title } })

    start_voting_session_params =
      Mural::StartVotingSessionParams.new.tap do |params|
        params.title = title
        params.number_of_votes = 2
        params.widget_types = ['sticky notes']

        params.area = Mural::StartVotingSessionParams::Area.new.tap do |area|
          area.top = 10
          area.left = 100
          area.width = 200
          area.height = 200
        end
      end

    voting_session = @client.mural_content.start_voting_session(
      mural_id,
      start_voting_session_params
    )

    assert_instance_of Mural::VotingSession, voting_session
    assert_equal 'voting-session-1', voting_session.id
    assert_equal title, voting_session.title
  end

  def test_end_voting_session
    mural_id = 'mural-1'

    end_session_request = stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      '/voting-sessions/end'
    ).to_return(status: 204)

    @client.mural_content.end_voting_session(mural_id)

    assert_requested end_session_request
  end

  def test_vote_for_widget
    mural_id = 'mural-1'
    widget_id = 'widget-1'

    vote_request = stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/voting-sessions/vote/#{widget_id}"
    ).to_return(status: 204)

    @client.mural_content.vote_for_widget(mural_id, widget_id)

    assert_requested vote_request
  end

  def test_list_voting_session_results
    mural_id = 'mural-1'
    voting_session_id = 'voting-session-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}" \
      "/voting-sessions/#{voting_session_id}/results"
    ).to_return_json(
      body: {
        value: [
          {
            widgetId: 'widget-1',
            totalVotes: 5,
            uniqueVoters: 2
          }
        ]
      }
    )

    results, = @client.mural_content.list_voting_session_results(
      mural_id,
      voting_session_id
    )

    assert_equal 1, results.size

    result = results.first

    assert_instance_of Mural::VotingSessionResult, result
    assert_equal 'widget-1', result.widget_id
    assert_equal 5, result.total_votes
    assert_equal 2, result.unique_voters
  end

  def test_retrieve_timer
    mural_id = 'mural-1'

    stub_request(
      :get,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/timer"
    ).to_return_json(
      body: {
        value: {
          duration: 1,
          initialTimestamp: 2,
          now: 3,
          pausedTimestamp: nil,
          soundEnabled: true
        }
      }
    )

    timer = @client.mural_content.retrieve_timer(mural_id)

    assert_instance_of Mural::Timer, timer
    assert_equal 1, timer.duration
    assert_equal 2, timer.initial_timestamp
    assert_equal 3, timer.now
    assert_nil timer.paused_timestamp
    assert timer.sound_enabled
  end

  def test_start_timer
    mural_id = 'mural-1'

    stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/timer/start"
    )
      .with(body: { duration: 1, soundEnabled: false })
      .to_return_json(
        body: {
          value: {
            duration: 1,
            initialTimestamp: 2,
            now: 3,
            pausedTimestamp: nil,
            soundEnabled: false
          }
        }
      )

    timer = @client.mural_content.start_timer(
      mural_id,
      duration: 1,
      sound_enabled: false
    )

    assert_instance_of Mural::Timer, timer
    assert_equal 1, timer.duration
    assert_equal 2, timer.initial_timestamp
    assert_equal 3, timer.now
    assert_nil timer.paused_timestamp
    refute timer.sound_enabled
  end

  def test_end_timer
    mural_id = 'mural-1'

    end_timer_request = stub_request(
      :post,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/timer/end"
    ).to_return(status: 204)

    @client.mural_content.end_timer(mural_id)

    assert_requested end_timer_request
  end

  def test_update_timer
    mural_id = 'mural-1'

    stub_request(
      :patch,
      "https://app.mural.co/api/public/v1/murals/#{mural_id}/timer"
    )
      .with(body: { delta: 10, soundEnabled: false, paused: true })
      .to_return_json(
        body: {
          value: {
            duration: 1,
            initialTimestamp: 2,
            now: 3,
            pausedTimestamp: 4,
            soundEnabled: false
          }
        }
      )

    update_timer_params = Mural::UpdateTimerParams.new.tap do |params|
      params.delta = 10
      params.sound_enabled = false
      params.paused = true
    end

    timer = @client.mural_content.update_timer(mural_id, update_timer_params)

    assert_instance_of Mural::Timer, timer
    assert_equal 1, timer.duration
    assert_equal 2, timer.initial_timestamp
    assert_equal 3, timer.now
    assert_equal 4, timer.paused_timestamp
    refute timer.sound_enabled
  end
end
