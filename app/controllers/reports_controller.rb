class ReportsController < ApplicationController
  require 'octokit'
  require 'fileutils'

  before_action :authenticate_user!, :enforce_github_link!, :set_course
  before_action :set_assignment, except: :course_reports

  def new
    @report = Report.new
  end

  def show; end

  def create
    repos = client.org_repos(@course.login).select { |repo| repo.name.include? "#{@assignment.name}" }

    # TODO move the file and report creation to background jobs
    repos.each do |repo|
      contents = client.contents(org_repo_name(repos.first.name), path: params[:report][:main_file_name])

      if contents.kind_of?(Array)
        flash[:alert] = 'No file with the given filename'
        redirect_to course_assignment_report_new_path
      else
        # Create directory for assignment if it doesnt exists
        directory_name = "storage/#{@course.login}/#{@assignment.name}"
        FileUtils.mkdir_p(directory_name) unless File.directory?(directory_name)

        # Write file content
        content = Base64.decode64(contents.content)
        File.write("#{directory_name}/#{repo.name}.rb", content)

        redirect_to course_assignment_report_path
      end
    end
  end

  def course_reports
    @course.reports
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_assignment
    @assignment = Assignment.find(params[:assignment_id])
  end

  def org_repo_name(repo_name)
    "#{@course.login}/#{repo_name}"
  end

  def client
    Octokit::Client.new(access_token: current_user.github_auth_token.access_token)
  end
end
