# frozen_string_literal: true

class CoursePolicy
  attr_reader :user, :course

  def initialize(user, course)
    @user = user
    @course = course
  end

  def show?
    owns?
  end

  def destroy?
    owns?
  end

  private

  def owns?
    @course.users.include? @user
  end
end
