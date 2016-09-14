describe Country, type: :model do
  let!(:country)      { FactoryGirl.create :country }
  let!(:user)         { FactoryGirl.create :user }
  let!(:country_user) { CountryUser.find_by user: user, country: country }

  describe 'visited?' do
    context 'when visited contry' do
      before do
        country_user.update_attributes(visited: true)
      end

      subject { country.visited? user }

      it { is_expected.to eq true }
    end

    context 'when not visited contry' do
  	  before do
        country_user.update_attributes(visited: false)
      end

      subject { country.visited? user }

      it { is_expected.to eq false }
    end
  end
end
