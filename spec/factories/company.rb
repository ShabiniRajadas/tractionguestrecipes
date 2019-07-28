FactoryBot.define do
  # The model spec file company_spec.rb get loaded before the factories and throws duplicate error
  # So company renamed as :company_record
  factory :company_record, class: Company do
    sequence(:uid) { |n| "#{n}-company" }
    sequence(:name) { |n| "Company Name #{n}"}
    url { 'testing.com'}
    description { 'Testing' }
  end
end