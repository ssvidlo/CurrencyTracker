class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :create_country_user

  has_many :country_users
  has_many :countries, through: :country_users

  private

  def create_country_user
    Country.all.each do |country|
      CountryUser.create country: country, user: self
    end
  end
end
