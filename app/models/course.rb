# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :course_assignments, dependent: :destroy
  has_many :assignments, through: :course_assignments
  has_many :reports, through: :assignments

  validates :login, :url, :html_url, :avatar_url, presence: true
  validates :login, uniqueness: true

  FROM_ORG_KEYS = %i[login name description url html_url avatar_url].freeze
end
