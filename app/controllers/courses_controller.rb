# frozen_string_literal: true

class CoursesController < ApplicationController
  require 'octokit'

  before_action :authenticate_user!

  def index; end

  def show; end

  def new
    @orgs = client.organizations
  end

  def create; end

  def destroy; end

  private

  def client
    Octokit::Client.new(access_token: current_user.github_auth_token.access_token)
  end
end
