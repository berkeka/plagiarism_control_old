# frozen_string_literal: true

class AssignmentPolicy
  attr_reader :user, :assignment

  def initialize(user, assignment)
    @user = user
    @assignment = assignment
  end

  def index?
    owns_collection?
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

  private

  def owns?
    @assignment.course.users.include? @user
  end

  def owns_collection?
    @assignment.first.course.users.include? @user
  end
end
