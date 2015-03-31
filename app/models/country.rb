class Country < ActiveRecord::Base
  self.primary_key = :code

  validates :name, :code, presence: true
  validates :code, uniqueness: true

  has_many :currencies

  accepts_nested_attributes_for :currencies, :allow_destroy => true

  scope :visited, -> { where(visited: true) }
  scope :not_visited, -> { where(visited: false) }
end
