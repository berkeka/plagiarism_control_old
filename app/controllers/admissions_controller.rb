# frozen_string_literal: true

class AdmissionsController < ApplicationController
  require 'octokit'

  before_action :authenticate_user!, :enforce_github_link!, :set_course, :set_assignment

  def index
    @repos = client.org_repos(@course.login).select { |repo| repo.name.include? "#{@assignment.name}-" }
  end

  private

  def client
    Octokit::Client.new(access_token: current_user.github_auth_token.access_token)
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_assignment
    @assignment = Assignment.find(params[:assignment_id])
  end
end
