# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def enforce_github_link!
    return if github_linked?

    flash[:alert] = t('github.required_error')
    redirect_to edit_user_registration_path
  end

  def github_linked?
    !current_user.github_auth_token.nil?
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:alert] = t "#{policy_name}.#{exception.query}", scope: 'pundit', default: :default
    redirect_back(fallback_location: root_path)
  end
end
