FactoryBot.define do
  # The model spec file company_spec.rb gets loaded
  # before the factories and throws duplicate error
  # So company renamed as :company_record
  factory :user do
    sequence(:email) { |n| "sample@test#{n}.com" }
    password { 'password' }
  end
end
