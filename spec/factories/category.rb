FactoryBot.define do
  factory :category_record, class: Category do
    sequence(:name) { |n| "sample#{n}" }
    association :company, factory: :company_record
  end
end
