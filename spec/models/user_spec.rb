describe User, type: :model do
  context 'when create user should be create country user record' do
    let!(:country) { FactoryGirl.create :country }
    let(:user) { FactoryGirl.build :user }

    it { expect { user.save }.to change { User.count }.by(1).and change { CountryUser.count }.by(1) }
  end
end