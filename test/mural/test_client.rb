# frozen_string_literal: true

require 'test_helper'

class TestClient < Minitest::Test
  def setup
    @client = Mural::Client.new.tap do |client|
      client.client_id = 'cid'
      client.redirect_uri = 'https://example.com/callback'
      client.scope = 'rooms:read identity:read'
    end
  end

  def test_authorize_url
    assert_equal(
      'https://app.mural.co/api/public/v1/authorization/oauth2/?client_id=cid&redirect_uri=https%3A%2F%2Fexample.com%2Fcallback&scope=rooms%3Aread+identity%3Aread&response_type=code',
      @client.authorize_url
    )
  end

  def test_initialize_from_env
    fake_env = lambda do |name, default_value = nil|
      return 'test.mural.co' if name == 'MURAL_HOST'

      default_value
    end

    ENV.stub :fetch, fake_env do
      other_client = Mural::Client.from_env

      assert_equal 'test.mural.co', other_client.host
    end
  end

  def test_retry_request_given_expired_token
    stub_request(:get, 'https://app.mural.co/fake-path')
      .to_return_json(
        { body: { code: 'TOKEN_EXPIRED' }, status: 403 },
        { body: { msg: 'foobar' } }
      )

    refresh_request = stub_request(
      :post,
      'https://app.mural.co/api/public/v1/authorization/oauth2/token'
    ).to_return_json(body: {})

    assert_equal 'foobar', @client.get('/fake-path')['msg']
    assert_requested refresh_request
  end

  def test_authorized_request_given_access_token
    @client.access_token = 'very-secret-token'

    stub_request(:get, 'https://app.mural.co/fake-path')
      .with(headers: { 'Authorization' => 'Bearer very-secret-token' })
      .to_return_json(body: { msg: 'success' })

    assert_equal 'success', @client.get('/fake-path')['msg']
  end

  def test_request_throws_mural_error
    stub_request(:get, 'https://app.mural.co/fake-path')
      .to_return_json(body: { code: 'FORBIDDEN' }, status: 403)

    assert_raises(Mural::Error) { @client.get('/fake-path') }
  end

  def test_request_token
    code = 'random-code'

    stub_request(
      :post,
      'https://app.mural.co/api/public/v1/authorization/oauth2/token'
    ).with(
      body: {
        client_id: @client.client_id,
        client_secret: @client.client_secret,
        redirect_uri: @client.redirect_uri,
        code: code,
        grant_type: 'authorization_code'
      }
    ).to_return_json(
      body: {
        access_token: 'some-access-token',
        refresh_token: 'some-refresh-token',
        expires_in: 123
      }
    )

    data = @client.request_token(code)

    assert_equal 'some-access-token', data['access_token']
    assert_equal 'some-access-token', @client.access_token

    assert_equal 'some-refresh-token', data['refresh_token']
    assert_equal 'some-refresh-token', @client.refresh_token
  end
end
