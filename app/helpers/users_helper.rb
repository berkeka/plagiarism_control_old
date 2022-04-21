# frozen_string_literal: true

module UsersHelper
  require Rails.root.join('app/services/github.rb')
  def auth_url
    Github.authorize_url
  end
end
