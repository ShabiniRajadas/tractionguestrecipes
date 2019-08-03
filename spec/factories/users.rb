FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "sample@test#{n}.com" }
    password { 'password' }
    password_confirmation { 'password' }
    association :company, factory: :company
  end
end
