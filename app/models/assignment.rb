# frozen_string_literal: true

class Assignment < ApplicationRecord
  has_one :course_assignment, dependent: :destroy
  has_one :course, through: :course_assignment

  validates :name, presence: true

  FROM_REPO_KEYS = %i[name description].freeze
end
