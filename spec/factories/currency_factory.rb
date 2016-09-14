FactoryGirl.define do
  factory :currency do
    name            { Faker::Pokemon.name }
    code            { Faker::Internet.password(3).upcase }
    weight          { Faker::Number.positive }
    collector_value { Faker::Number.positive }
    country         { Country.first }
  end
end
