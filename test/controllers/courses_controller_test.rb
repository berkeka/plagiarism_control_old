# frozen_string_literal: true

require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
  end

  # test 'should get index' do
  #   get courses_url
  #   assert_response :success
  # end

  # test 'should get show' do
  #   get courses_url
  #   assert_response :success
  # end

  # test 'should get new' do
  #   get new_course_url
  #   assert_response :success
  # end
end
