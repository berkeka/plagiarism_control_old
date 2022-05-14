# frozen_string_literal: true

module Github
  GITHUB_BASE_URL = 'https://github.com/login/'
  OAUTH_AUTH_ENDPOINT_URL = 'oauth/authorize'
  OAUTH_TOKEN_ENDPOINT_URL = 'oauth/access_token'

  GITHUB_SCOPES = {
    email: %w[user],
    org:   %w[read]
  }.freeze

  class OAuthClient
    def initialize
      create_client
    end

    def make_token_request(auth_code)
      @connection.post(OAUTH_TOKEN_ENDPOINT_URL) do |req|
        req.body = {
          code:          auth_code,
          client_id:     Github.client_id,
          client_secret: Github.client_secret
        }.to_json
      end
    end

    private

    def create_client
      @connection = Faraday.new(url:     GITHUB_BASE_URL,
                                headers: { 'Content-Type' => 'application/json' })
    end
  end

  module_function

  def authorize_url
    "#{GITHUB_BASE_URL}#{OAUTH_AUTH_ENDPOINT_URL}?scope=#{scopes}&client_id=#{client_id}"
  end

  def client_id
    Rails.application.credentials.dig(:github, :client_id)
  end

  def client_secret
    Rails.application.credentials.dig(:github, :client_secret)
  end

  def scopes
    p GITHUB_SCOPES.map { |key, values| values.map { |value| "#{value}:#{key}" } }.join('+') + '+repo'
  end

  def get_params_from_body(body)
    Rack::Utils.parse_nested_query body
  end

  def token_valid?(token)
    token =~ /^v[0-9]\.[0-9a-f]{40}$/
  end
end
