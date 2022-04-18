# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    def edit
      @github_client_id = github_client_id
      super
    end

    private

    def github_client_id
      Rails.application.credentials.dig(:github, :client_id)
    end
  end
end
