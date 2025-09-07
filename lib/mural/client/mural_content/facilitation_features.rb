# frozen_string_literal: true

module Mural
  class Client
    class MuralContent
      module FacilitationFeatures
        # https://developers.mural.co/public/reference/startprivatemode
        def start_private_mode(mural_id, hide_authors: false)
          json = post(
            "/api/public/v1/murals/#{mural_id}/private-mode/start",
            { hideAuthors: hide_authors }
          )

          Mural::PrivateMode.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/stopprivatemode
        def end_private_mode(mural_id)
          post("/api/public/v1/murals/#{mural_id}/private-mode/end")
        end

        # https://developers.mural.co/public/reference/getprivatemode
        def retrieve_private_mode(mural_id)
          json = get("/api/public/v1/murals/#{mural_id}/private-mode")

          Mural::PrivateMode.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/getmuralvotingsessions
        def list_voting_sessions(mural_id, next_page: nil)
          json = get(
            "/api/public/v1/murals/#{mural_id}/voting-sessions",
            { next: next_page }
          )

          voting_sessions = json['value'].map do |session|
            Mural::VotingSession.decode(session)
          end

          [voting_sessions, json['next']]
        end

        # https://developers.mural.co/public/reference/getmuralvotingsessionresults
        def list_voting_session_results(
          mural_id,
          voting_session_id,
          next_page: nil
        )
          json = get(
            "/api/public/v1/murals/#{mural_id}/voting-sessions" \
            "/#{voting_session_id}/results",
            { next: next_page }
          )

          voting_session_results = json['value'].map do |result|
            Mural::VotingSessionResult.decode(result)
          end

          [voting_session_results, json['next']]
        end

        # https://developers.mural.co/public/reference/getmuralvotingsessionbyid
        def retrieve_voting_session(mural_id, voting_session_id)
          json = get(
            "/api/public/v1/murals/#{mural_id}/voting-sessions" \
            "/#{voting_session_id}"
          )

          Mural::VotingSession.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/deletemuralvotingsessionbyid
        def destroy_voting_session(mural_id, voting_session_id)
          delete(
            "/api/public/v1/murals/#{mural_id}/voting-sessions" \
            "/#{voting_session_id}"
          )
        end

        # https://developers.mural.co/public/reference/startmuralvotingsession
        def start_voting_session(mural_id, start_voting_session_params)
          json = post(
            "/api/public/v1/murals/#{mural_id}/voting-sessions/start",
            start_voting_session_params.encode
          )

          Mural::VotingSession.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/endmuralvotingsession
        def end_voting_session(mural_id)
          post("/api/public/v1/murals/#{mural_id}/voting-sessions/end")
        end

        # https://developers.mural.co/public/reference/votewidgetmuralvotingsession
        def vote_for_widget(mural_id, widget_id)
          post(
            "/api/public/v1/murals/#{mural_id}/voting-sessions" \
            "/vote/#{widget_id}"
          )
        end

        # https://developers.mural.co/public/reference/getmuraltimer
        def retrieve_timer(mural_id)
          json = get("/api/public/v1/murals/#{mural_id}/timer")

          Mural::Timer.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/startmuraltimer
        def start_timer(mural_id, duration:, sound_enabled: true)
          json = post(
            "/api/public/v1/murals/#{mural_id}/timer/start",
            { duration: duration, soundEnabled: sound_enabled }
          )

          Mural::Timer.decode(json['value'])
        end

        # https://developers.mural.co/public/reference/stopmuraltimer
        def end_timer(mural_id)
          post("/api/public/v1/murals/#{mural_id}/timer/end")
        end

        # https://developers.mural.co/public/reference/updatemuraltimer
        def update_timer(mural_id, update_timer_params)
          json = patch(
            "/api/public/v1/murals/#{mural_id}/timer",
            update_timer_params.encode
          )

          Mural::Timer.decode(json['value'])
        end
      end
    end
  end
end
