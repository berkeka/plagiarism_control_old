# frozen_string_literal: true

class CoursesController < ApplicationController
  require 'octokit'

  before_action :authenticate_user!
  before_action :enforce_github_link!, only: %i[new create]
  before_action :set_course, only: :show

  def index
    @courses = current_user.courses
  end

  def show
    authorize @course
  end

  def new
    @orgs = client.organizations
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def create
    org = client.organization(course_params[:name])
    existing_course = Course.find_by(login: org.login)

    if existing_course
      if existing_course.users.include? current_user
        existing_course.users << current_user unless 
        existing_course.save

        redirect_to existing_course, notice: t('courses.exists_added')
      else
        redirect_to existing_course, notice: t('courses.exists')
      end
    else
      @course = Course.new(org_to_course_params(org))
      @course.users << current_user

      if @course.save
        redirect_to @course, notice: t('courses.created')
      else
        redirect_to new_course_path, alert: @course.errors
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def destroy; end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name)
  end

  def org_to_course_params(org)
    org.to_h.select { |k, _| Course::FROM_ORG_KEYS.include? k }
  end

  def client
    Octokit::Client.new(access_token: current_user.github_auth_token.access_token)
  end
end
