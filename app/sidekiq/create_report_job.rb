# frozen_string_literal: true

class CreateReportJob
  include Sidekiq::Job

  require 'csv'
  require 'fileutils'

  # rubocop:disable Metrics/MethodLength
  def perform(assignment_id, report_id, contents, extension)
    assignment = Assignment.find(assignment_id)
    course = assignment.course
    report = Report.find(report_id)

    language = Report::LANGUAGES[extension]

    #  Create directory for assignment if it doesnt exists
    directory_name = "storage/#{course.login}/#{assignment.name}"
    FileUtils.mkdir_p(directory_name) unless File.directory?(directory_name)

    contents.each do |repo_name, cryptic_content|
      #  Write file content
      content = Base64.decode64(cryptic_content)
      File.write("#{directory_name}/#{repo_name}.#{extension}", content)
    end

    #  Generate plagiarism report
    return_val = system "yarn dolos run -f csv -l #{language} #{directory_name}/*.#{extension} -o #{directory_name}/report"

    report.update(status: :done) if return_val
  end
  # rubocop:enable Metrics/MethodLength
end
