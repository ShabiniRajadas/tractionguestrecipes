FactoryBot.define do
  factory :recipe, class: 'Recipe' do
    sequence(:name) { |n| "Recipe#{n}" }
    description { 'Sub Recipe' }
    unit_price { 10.0 }
    association :company, factory: :company
    after(:create) do |recipe|
      recipe.ingredients << FactoryBot.create(:ingredient)
    end
  end
end
