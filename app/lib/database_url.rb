# frozen_string_literal: true

module DatabaseUrl
  module_function

  def application
    'plagiarism_control'
  end

  def url
    host = ENV.fetch('DB_HOST', 'localhost')
    "postgresql://#{application}:#{application}@#{host}/#{application}"
  end

  def development
    "#{url}_development"
  end

  def production
    db_url = ENV['DATABASE_URL']
    db_url.nil? ? "#{url}_production" : db_url
  end

  def test
    "#{url}_test"
  end
end
