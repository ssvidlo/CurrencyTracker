class CountryUser < ActiveRecord::Base
  belongs_to :country
  belongs_to :user
end