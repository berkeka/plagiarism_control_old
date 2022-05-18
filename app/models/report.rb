class Report < ApplicationRecord
  belongs_to :assignment

  after_initialize :set_default_status, if: :new_record?
  after_destroy :clean_report_files

  enum status: { ongoing: 0, done: 1 }

  private

  def set_default_status
    self.status ||= :ongoing
  end

  def clean_report_files
    assignment = self.assignment
    course = assignment.course
    FileUtils.rm_rf("storage/#{course.login}/#{assignment.name}")
  end
end
