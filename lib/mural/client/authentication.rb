# frozen_string_literal: true

module Mural
  class Client
    module Authentication
      def authorize_url
        URI::HTTPS.build(
          host: host,
          path: '/api/public/v1/authorization/oauth2/',
          query: URI.encode_www_form(authorize_query)
        ).to_s
      end

      def request_token(code)
        uri = URI::HTTPS.build(
          host: host,
          path: '/api/public/v1/authorization/oauth2/token'
        )

        res = Net::HTTP.post_form(uri, request_token_payload(code))
        data = JSON.parse res.body

        @access_token = data['access_token']
        @refresh_token = data['refresh_token']

        data
      end

      def refresh
        uri = URI::HTTPS.build(
          host: host,
          path: '/api/public/v1/authorization/oauth2/token'
        )

        res = Net::HTTP.post_form(uri, refresh_token_payload)
        json = JSON.parse res.body

        @access_token = json['access_token']
        @refresh_token = json['refresh_token']

        nil
      end

      private

      def authorize_query
        {
          client_id: client_id,
          redirect_uri: redirect_uri,
          scope: scope,
          response_type: 'code'
        }
      end

      def request_token_payload(code)
        {
          client_id: client_id,
          client_secret: client_secret,
          redirect_uri: redirect_uri,
          code: code,
          grant_type: 'authorization_code'
        }
      end

      def refresh_token_payload
        {
          client_id: client_id,
          client_secret: client_secret,
          refresh_token: refresh_token,
          grant_type: 'refresh_token'
        }
      end
    end
  end
end
