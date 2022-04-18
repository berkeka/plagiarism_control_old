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
    "#{url}_production"
  end

  def test
    "#{url}_test"
  end
end
