# frozen_string_literal: true

module Mural
  class Client
    include ::Mural::Client::Authentication

    ENV_VARS = {
      host: 'MURAL_HOST',
      client_id: 'MURAL_CLIENT_ID',
      client_secret: 'MURAL_CLIENT_SECRET',
      redirect_uri: 'MURAL_REDIRECT_URI',
      scope: 'MURAL_SCOPE',
      access_token: 'MURAL_ACCESS_TOKEN',
      refresh_token: 'MURAL_REFRESH_TOKEN'
    }.freeze

    def self.from_env
      new.tap do |client|
        ENV_VARS.each do |attr, env_var|
          value = ENV.fetch(env_var, nil)

          client.public_send(:"#{attr}=", value) unless value.nil?
        end
      end
    end

    ENV_VARS.each_key do |attr|
      attr_accessor(attr)
    end

    attr_reader :mural_content, :murals, :rooms, :search, :templates, :users,
                :workspaces

    def initialize
      @host = 'app.mural.co'

      @mural_content = Mural::Client::MuralContent.new(self)
      @murals = Mural::Client::Murals.new(self)
      @rooms = Mural::Client::Rooms.new(self)
      @search = Mural::Client::Search.new(self)
      @templates = Mural::Client::Templates.new(self)
      @users = Mural::Client::Users.new(self)
      @workspaces = Mural::Client::Workspaces.new(self)
    end

    def get(path, query = {})
      uri = URI::HTTPS.build(
        host: host,
        path: path,
        query: URI.encode_www_form(query.compact)
      )

      req = Net::HTTP::Get.new uri
      # retryable_request(req)
      retryable_request(req)
    end

    def post(path, body = {})
      uri = URI::HTTPS.build(host: host, path: path)
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/json'
      req.body = body.compact.to_json

      retryable_request(req)
    end

    def patch(path, body = {})
      uri = URI::HTTPS.build(host: host, path: path)
      req = Net::HTTP::Patch.new(uri)
      req['Content-Type'] = 'application/json'
      req.body = body.compact.to_json

      retryable_request(req)
    end

    def delete(path)
      uri = URI::HTTPS.build(host: host, path: path)
      req = Net::HTTP::Delete.new(uri)

      retryable_request(req)
    end

    private

    def retryable_request(request)
      res = authorized_request(request)
      return if res.is_a?(Net::HTTPNoContent)

      data = JSON.parse(res.body)
      raise to_error(data) unless res.is_a?(Net::HTTPOK) ||
                                  res.is_a?(Net::HTTPCreated)

      data
    rescue StandardError => e
      raise unless e.respond_to?(:code) && e.code == 'TOKEN_EXPIRED'

      refresh
      retry
    end

    def authorized_request(request)
      Net::HTTP.start(
        request.uri.host,
        request.uri.port,
        use_ssl: request.uri.scheme == 'https'
      ) do |http|
        request['Authorization'] = "Bearer #{access_token}"
        http.request request
      end
    end

    def to_error(data)
      message = data.fetch('message', 'unknown error')
      code = data.fetch('code', 'unknown code')

      Mural::Error.new(message, code: code, details: data['details'])
    end
  end
end
