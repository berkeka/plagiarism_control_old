# frozen_string_literal: true

module Github
  class OAuthClient
    GITHUB_BASE_URL = 'https://github.com/login/'
    OAUTH_ENDPOINT_URL = 'oauth/access_token'

    def initialize
      create_client
    end

    def make_token_request(auth_code)
      @connection.post(OAUTH_ENDPOINT_URL) do |req|
        req.body = {
          code:          auth_code,
          client_id:     Rails.application.credentials.dig(:github, :client_id),
          client_secret: Rails.application.credentials.dig(:github, :client_secret)
        }.to_json
      end
    end

    private

    def create_client
      @connection = Faraday.new(url:     GITHUB_BASE_URL,
                                headers: { 'Content-Type' => 'application/json' })
    end
  end

  def self.get_params_from_body(body)
    Rack::Utils.parse_nested_query body
  end

  def self.token_valid?(token)
    token =~ /^v[0-9]\.[0-9a-f]{40}$/
  end
end
