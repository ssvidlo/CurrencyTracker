FactoryGirl.define do
  factory :user do
    email                { Faker::Internet.email }
    password             { Faker::Internet.password(8) }
    authentication_token { Faker::Internet.password(30) }
  end
end
