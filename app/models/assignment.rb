# frozen_string_literal: true

class Assignment < ApplicationRecord
  has_one :course_assignment, dependent: :destroy
  has_one :course, through: :course_assignment

  has_one :report, dependent: :destroy

  validates :name, presence: true

  FROM_REPO_KEYS = %i[name description].freeze
end
