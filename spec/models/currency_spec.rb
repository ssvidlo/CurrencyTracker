describe User, type: :model do
  let!(:country) { FactoryGirl.create :country }
  let!(:currency) { FactoryGirl.create(:currency, country: country) }
  let!(:user) { FactoryGirl.create :user }
  let!(:country_user) { CountryUser.find_by(user: user, country: country) }

  describe '#collected?' do
    before { country_user.update_attributes(visited: true) }

    subject { currency.collected? user }

    it { is_expected.to eq true }
  end

  describe '.not_collected and .collected' do
    let!(:country1)      { FactoryGirl.create(:country, name: 'Albania', code: 'al') }
    let!(:country2)      { FactoryGirl.create(:country, name: 'Algeria', code: 'dz') }
    let!(:country3)      { FactoryGirl.create(:country, name: 'American Samoa', code: 'as') }
    let! :currency1 do
      FactoryGirl.create :currency,
        country: country1,
        name: 'Afghani',
        code: 'AFA',
        weight: "3.59144658850593",
        collector_value: "7.820516121919"
    end
    let! :currency2 do
      FactoryGirl.create :currency,
        name: 'Lek',
        code: 'ALL',
        weight: '2.74041828894157',
        collector_value: '1.74565844472991',
        country: country2
    end
    let! :currency3 do
      FactoryGirl.create :currency,
        name: 'Dinar',
        code: 'DZD',
        weight: '4.02363006175925',
        collector_value: '1.80104808337808',
        country: country3
    end
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