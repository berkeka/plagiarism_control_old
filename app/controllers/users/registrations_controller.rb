# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def edit
      @is_github_linked = !!current_user.github_auth_token
      super
    end
  end
end
