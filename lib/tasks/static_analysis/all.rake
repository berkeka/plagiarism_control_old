# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  namespace :static_analysis do
    desc 'Run all tasks'
    task all: %i[rubocop]
  end
end
