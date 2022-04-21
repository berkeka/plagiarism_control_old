# frozen_string_literal: true

class GithubAuthToken < ApplicationRecord
  belongs_to :user
  encrypts :access_token, deterministic: true
end
