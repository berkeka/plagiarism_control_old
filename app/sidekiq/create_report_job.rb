# frozen_string_literal: true

class CreateReportJob
  include Sidekiq::Job

  require 'csv'
  require 'fileutils'
  require 'octokit'

  # rubocop:disable Metrics/MethodLength, Layout/LineLength, Metrics/AbcSize
  def perform(assignment_id, report_id, repo_names, token)
    assignment = Assignment.find(assignment_id)
    course = assignment.course
    report = Report.find(report_id)

    extension = file_extension(report.main_file_name)
    language = Report::LANGUAGES[extension]

    #  Create directory for assignment if it doesnt exists
    directory_name = "storage/#{course.login}/#{assignment.name}"
    FileUtils.mkdir_p(directory_name) unless File.directory?(directory_name)

    repo_names.each do |repo_name|
      response = client(token).contents("#{course.login}/#{repo_name}", path: report.main_file_name).to_h

      #  Write file content
      content = Base64.decode64(response[:content]).force_encoding('UTF-8')
      File.write("#{directory_name}/#{repo_name}.#{extension}", content)
    end

    #  Generate plagiarism report
    return_val = system "yarn dolos run -f csv -l #{language} #{directory_name}/*.#{extension} -o #{directory_name}/report"

    report.update(status: :done) if return_val
  end
  # rubocop:enable Metrics/MethodLength, Layout/LineLength, Metrics/AbcSize

  def client(token)
    @client ||= Octokit::Client.new(access_token: token)
    @client.auto_paginate = true

    @client
  end

  def file_extension(filename)
    File.extname(filename).delete('.')
  end
end
