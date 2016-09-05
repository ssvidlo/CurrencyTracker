class Country < ActiveRecord::Base
  self.primary_key = :code

  validates :name, :code, presence: true
  validates :code, uniqueness: true

  has_many :currencies
  has_many :country_users

  accepts_nested_attributes_for :currencies, :allow_destroy => true

  scope :visited, -> (user) { joins(:country_users).where(country_users: { user_id: user.id, visited: true}) }
  scope :not_visited, -> (user) { joins(:country_users).where(country_users: { user_id: user.id, visited: false}) }

  searchable do
    text :name, :code
  end

  def visited? user
    CountryUser.find_by(user: user, country: self).visited
  end
end
