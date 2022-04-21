# frozen_string_literal: true

module Users
  class OauthCallbacksController < ApplicationController
    require Rails.root.join('app/services/github.rb')
    before_action :authenticate_user!

    def github # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      client = Github::OAuthClient.new
      response = client.make_token_request(params['code'])
      response_params = Github.get_params_from_body(response.body)

      if response_params.key?('access_token')
        token_string = response_params['access_token']

        auth_token = UserGithubAuthToken.find_by(user_id: current_user.id) ||
                     UserGithubAuthToken.new(access_token: token_string)

        current_user.update(user_github_auth_token: auth_token)
        flash[:notice] = t('github_link_success')
      else
        flash[:alert] = response_params['error_description']
      end
      redirect_to edit_user_registration_path
    end

    def github_revoke
      if current_user.user_github_auth_token.destroy
        flash[:notice] = t('github_revoke_success')
      end
      redirect_to edit_user_registration_path
    end
  end
end
