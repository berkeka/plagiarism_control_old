# frozen_string_literal: true

class CoursesController < ApplicationController
  require 'octokit'

  before_action :authenticate_user!
  before_action :enforce_github_link!, only: %i[new]

  KEYS = %i[login name description url html_url avatar_url].freeze

  def index
    @courses = current_user.courses
  end

  def show; end

  def new
    @orgs = client.organizations
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def create
    org = client.organization(course_params['name'])
    existing_course = current_user.courses.find_by(login: org.login)

    if existing_course
      flash[:notice] = t('courses.already_registered')
      redirect_to new_course_path
    else
      @course = Course.new(org_to_course_params(org))
      current_user.courses << @course
      if @course.save
        redirect_to @course
      else
        flash[:notice] = @course.errors
        redirect_to new_course_path
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def destroy; end

  private

  def course_params
    params.require(:course).permit(:name)
  end

  def org_to_course_params(org)
    org.to_h.select { |k, _v| KEYS.include? k }
  end

  def client
    Octokit::Client.new(access_token: current_user.github_auth_token.access_token)
  end
end
