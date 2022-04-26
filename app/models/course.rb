# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses

  validates :login, :name, :url, :html_url, :avatar_url, :description, presence: true
  validates :login, uniqueness: true
end
