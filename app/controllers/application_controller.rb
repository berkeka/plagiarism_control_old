# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def enforce_github_link!
    unless github_linked?
      flash[:alert] = 'This action requires a Github link to be present.'
      redirect_to edit_user_registration_path
    end
  end

  def github_linked?
    !current_user.github_auth_token.nil?
  end
end
