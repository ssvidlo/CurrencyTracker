FactoryGirl.define do
  factory :country_user do
    user    User.first
    country Country.first
  end
end
