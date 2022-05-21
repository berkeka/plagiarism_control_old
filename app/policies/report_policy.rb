# frozen_string_literal: true

class ReportPolicy
  attr_reader :user, :report

  def initialize(user, report)
    @user = user
    @report = report
  end

  def show?
    owns?
  end

  def new?
    owns?
  end

  def create?
    owns?
  end

  def destroy?
    @report && owns?
  end

  def course_reports?
    @report && owns_collection?
  end

  private

  def owns?
    @report.assignment.course.users.include? @user
  end

  def owns_collection?
    @report.first&.assignment&.course&.users.include? @user
  end
end
