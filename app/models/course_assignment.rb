# frozen_string_literal: true

class CourseAssignment < ApplicationRecord
  belongs_to :course
  belongs_to :assignment
end
