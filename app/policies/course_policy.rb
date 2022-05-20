class CoursePolicy
  attr_reader :user, :course

  def initialize(user, course)
    @user = user
    @course = course
  end

  def show?
    @course.users.include? @user
  end

  def destroy?
    show?
  end
end
