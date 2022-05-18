class CreateReportJob
  include Sidekiq::Job

  require 'csv'
  require 'fileutils'

  def perform(assignment_id, report_id, contents)
    assignment = Assignment.find(assignment_id)
    course = assignment.course
    report = Report.find(report_id)

    contents.each do |repo_name, cryptic_content|
      # Create directory for assignment if it doesnt exists
      directory_name = "storage/#{course.login}/#{assignment.name}"
      FileUtils.mkdir_p(directory_name) unless File.directory?(directory_name)

      # Write file content
      content = Base64.decode64(cryptic_content)
      File.write("#{directory_name}/#{repo_name}.rb", content)
    end

    # Generate plagiarism report
    return_val = system "yarn dolos run -f csv -l ruby #{directory_name}/*.rb -o #{directory_name}/report"

    Report.update(status: :done) if return_val
  end
end
