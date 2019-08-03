FactoryBot.define do
  factory :ingredient, class: 'Ingredient' do
    sequence(:name) { |n| "sample#{n}" }
    unit_price { 10.0 }
    measurement_unit { 1 }
    association :company, factory: :company
  end
end
