class Currency < ActiveRecord::Base
  self.primary_key = :code

  validates :name, :code, :weight, :collector_value, presence: true
  validates :code, uniqueness: true

  belongs_to :country

  def self.collected user
    all.select {|currency| currency.collected?(user) }
  end

  def self.not_collected user
    all.reject {|currency| currency.collected?(user)}
  end

  def collected? user
    country.nil? ? false : country.visited?(user)
  end
end
