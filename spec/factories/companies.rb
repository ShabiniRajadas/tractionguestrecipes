FactoryBot.define do
  factory :company, class: 'Company' do
    sequence(:uid) { |n| "#{n}-company" }
    sequence(:name) { |n| "Company Name #{n}" }
    url { 'testing.com' }
    description { 'Testing' }
  end
end
