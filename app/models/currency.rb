class Currency < ActiveRecord::Base
  self.primary_key = :code

  validates :name, :code, :weight, :collector_value, presence: true
  validates :code, uniqueness: true

  belongs_to :country

  def self.collected
    all.select {|currency| currency.collected? }
  end

  def self.not_collected
    all.reject {|currency| currency.collected? }
  end

  def collected?
    country.nil? ? false : country.visited?
  end
end
