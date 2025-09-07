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
        def stop_private_mode(mural_id)
          post("/api/public/v1/murals/#{mural_id}/private-mode/stop")
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
      end
    end
  end
end
