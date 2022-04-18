# frozen_string_literal: true

if Rails.env.development?
  # Seed first user
  [
    {
      email:        'cezmi@stu.omu.edu.tr',
    }
  ].each do |args|
    User.create(**args, password: '123456', password_confirmation: '123456')
  end
end
