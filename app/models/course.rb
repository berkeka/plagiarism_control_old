# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses
  has_many :course_assignments, dependent: :destroy
  has_many :assignments, through: :course_assignments

  validates :login, :name, :url, :html_url, :avatar_url, :description, presence: true
  validates :login, uniqueness: true
end
