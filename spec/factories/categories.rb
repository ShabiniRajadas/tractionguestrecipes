FactoryBot.define do
  factory :category, class: 'Category' do
    sequence(:name) { |n| "sample#{n}" }
    association :company, factory: :company
  end
end
