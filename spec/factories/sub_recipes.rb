FactoryBot.define do
  factory :sub_recipe, class: 'SubRecipe' do
    sequence(:name) { |n| "SubRecipe#{n}" }
    description { 'Sub Recipe' }
    unit_price { 10.0 }
    after(:create) do |sub_recipe|
      sub_recipe.ingredients << FactoryBot.create(:ingredient)
    end
  end
end
