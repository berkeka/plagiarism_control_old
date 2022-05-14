# frozen_string_literal: true

class AssignmentsController < ApplicationController
  require 'octokit'

  before_action :authenticate_user!
  before_action :enforce_github_link!, only: %i[show new create]
  before_action :set_course

  def index
    @assignments = @course.assignments
  end

  def show
    @assignment = Assignment.find(params[:id])
    @repos = client.org_repos(@course.login).select { |repo| repo.name.include? @assignment.name }
  end

  def new
    @repos = client.org_repos(@course.login).select(&:is_template)
  end

  # rubocop:disable Metrics/AbcSize
  def create
    repo = client.repo(org_repo_name(assignment_params[:name]))
    @assignment = Assignment.new(repo_to_assignment_params(repo))
    @assignment.course = @course

    if @assignment.save
      redirect_to course_assignment_path(course_id: @course.id, id: @assignment.id)
    else
      flash[:alert] = @assignment.errors
      redirect_to new_course_assignment_path
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def assignment_params
    params.require(:assignment).permit(:name)
  end

  def repo_to_assignment_params(repo)
    repo.to_h.select { |k, _| Assignment::FROM_REPO_KEYS.include? k }
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def org_repo_name(repo_name)
    "#{@course.login}/#{repo_name}"
  end

  def client
    Octokit::Client.new(access_token: current_user.github_auth_token.access_token)
  end
end
