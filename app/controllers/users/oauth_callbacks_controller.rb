# frozen_string_literal: true
module Users
  class OauthCallbacksController < ApplicationController
    require "#{Rails.root}/app/services/github.rb"
    before_action :authenticate_user!

    def github
      client = Github::OAuthClient.new
      response = client.make_token_request(params['code'])
      response_params = Github::get_params_from_body(response.body)

      if response_params.has_key?('access_token')
        token_string = response_params['access_token']

        auth_token = UserGithubAuthToken.find_by(user_id: current_user.id) || UserGithubAuthToken.new(access_token: token_string)
        
        current_user.update(user_github_auth_token: auth_token)
        flash[:notice] = 'Github account added succesfully.'
      else
        flash[:alert] = response_params['error_description']
      end
      redirect_to edit_user_registration_path
    end
  end
end
