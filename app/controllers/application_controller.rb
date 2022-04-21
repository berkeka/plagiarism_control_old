# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def enforce_github_link!
    return if github_linked?

    flash[:alert] = t('github_required_error')
    redirect_to edit_user_registration_path
  end

  def github_linked?
    !current_user.github_auth_token.nil?
  end
end
