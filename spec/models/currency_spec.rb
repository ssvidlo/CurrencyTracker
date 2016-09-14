describe User, type: :model do
  let!(:country)      { FactoryGirl.create :country }
  let!(:currency)     { FactoryGirl.create(:currency, country: country) }
  let!(:user)         { FactoryGirl.create :user }
  let!(:country_user) { CountryUser.find_by(user: user, country: country) }

  describe '#collected?' do
    before { country_user.update_attributes(visited: true) }

    subject { currency.collected? user }

    it { is_expected.to eq true }
  end

  describe '.not_collected and .collected' do
    let!(:country1)      { FactoryGirl.create :country }
    let!(:country2)      { FactoryGirl.create :country }
    let!(:country3)      { FactoryGirl.create :country }
    let!(:currency1)     { FactoryGirl.create :currency, country: country1 }
    let!(:currency2)     { FactoryGirl.create :currency, country: country2 }
    let!(:currency3)     { FactoryGirl.create :currency, country: country3 }
    let!(:country_user1) { FactoryGirl.create(:country_user, country: country1, user: user, visited: false) }
    let!(:country_user2) { FactoryGirl.create(:country_user, country: country2, user: user, visited: false) }
    let!(:country_user3) { FactoryGirl.create(:country_user, country: country3, user: user, visited: false) }

    describe '.not_collected' do

      subject { Currency.not_collected user }

      it { expect(subject.count).to eq 4 }
    end

    describe '.collected' do

  	  before do
        country_user1.update_attributes(visited: true)
        country_user2.update_attributes(visited: true)
        country_user3.update_attributes(visited: true)
      end

      subject { Currency.collected user }

      it { expect(subject.count).to eq 3 }
    end
  end
end
