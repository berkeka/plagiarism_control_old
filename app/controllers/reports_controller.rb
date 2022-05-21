# frozen_string_literal: true

class ReportsController < ApplicationController
  require 'octokit'
  require 'csv'

  before_action :authenticate_user!, :enforce_github_link!, :set_course
  before_action :set_assignment, except: :course_reports
  before_action :report_doesnt_exists?, only: :create

  def show
    @report = @assignment.report

    if @report
      authorize @report, policy_class: ReportPolicy

      if @report.done?
        @pairs = CSV.parse(File.read("#{report_path}/pairs.csv"), headers: true, converters: :numeric)
      else
        flash[:alert] = t('reports.ongoing')
      end
    else
      flash[:alert] = t('reports.none')
    end
  end

  def new
    @report = Report.new
    @report.assignment = @assignment

    authorize @report
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    report = Report.new(main_file_name: params[:report][:main_file_name], assignment_id: @assignment.id)
    authorize report

    repos = client.org_repos(@course.login).select { |repo| repo.name.include? "#{@assignment.name}-" }

    return redirect_to course_assignment_report_new_path, alert: t('reports.min_admission_error') if repos.count < 2

    #  Check if file with given main_file_name exists on github repos
    begin
      example_content = client.contents(org_repo_name(repos.first.name), path: params[:report][:main_file_name])
    rescue Octokit::NotFound
      redirect_to course_assignment_report_new_path, alert: t('reports.no_file_error')
    else
      if example_content.is_a?(Array)
        redirect_to course_assignment_report_new_path, alert: t('reports.filename_unspecified_error')
      else
        report.save

        contents = repos.each.each_with_object({}) do |repo, hash|
          content = client.contents(org_repo_name(repo.name), path: params[:report][:main_file_name]).to_h
          hash[repo.name] = content[:content]
        end

        CreateReportJob.perform_async(@assignment.id, report.id, contents)
        redirect_to course_assignment_report_path
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def destroy
    report = authorize @assignment.report, policy_class: ReportPolicy

    report.destroy
  end

  def course_reports
    @reports = authorize @course.reports, policy_class: ReportPolicy
  end

  private

  def report_params
    params.require(:report).permit(:main_file_name)
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_assignment
    @assignment = Assignment.find(params[:assignment_id])
  end

  def org_repo_name(repo_name)
    "#{@course.login}/#{repo_name}"
  end

  def report_doesnt_exists?
    redirect_to course_assignment_report_path unless @assignment.report.nil?
  end

  def report_path
    "storage/#{@course.login}/#{@assignment.name}/report"
  end

  def client
    Octokit::Client.new(access_token: current_user.github_auth_token.access_token)
  end
end
