# frozen_string_literal: true

module Users
  class OauthCallbacksController < ApplicationController
    require Rails.root.join('app/services/github.rb')

    before_action :authenticate_user!
    before_action :enforce_github_link!, only: %i[github_revoke]

    def github # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      client = Github::OAuthClient.new
      response = client.make_token_request(params['code'])
      response_params = Github.get_params_from_body(response.body)

      if response_params.key?('access_token')
        token_string = response_params['access_token']

        auth_token = GithubAuthToken.find_by(user_id: current_user.id) ||
                     GithubAuthToken.new(access_token: token_string)

        current_user.update(github_auth_token: auth_token)
        flash[:notice] = t('github.link_success')
      else
        flash[:alert] = response_params['error_description']
      end
      redirect_to edit_user_registration_path
    end

    def github_revoke
      if current_user.github_auth_token.destroy
        flash[:notice] = t('github.revoke_success')
      else
        flash[:alert] = t('github.revoke_error')
      end
      redirect_to edit_user_registration_path
    end
  end
end
