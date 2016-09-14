describe CurrenciesController, type: :controller do
  let!(:country)      { FactoryGirl.create :country }
  let!(:currency)     { FactoryGirl.create :currency, country: country }
  let!(:user)         { FactoryGirl.create :user }
  let!(:country_user) { CountryUser.find_by user: user, country: country }

  before do
    controller.request.headers['email'] = user.email
    controller.request.headers['auth_token'] = user.authentication_token
  end

  subject { decoded_json_response }

  describe 'GET /currencies', :search => true do
  	def dispatch parameters = {}
      get :index, parameters
    end

    before do
      Sunspot.commit
      dispatch
    end

    it { expect(subject['result'].size).to eq(1) }

    context 'when searching existing currency by code' do
      before do
        Sunspot.commit
        dispatch(search: currency.code)
      end

      it { expect(subject['result'].size).to eq(1) }
    end

    context 'when searching existing currency by name' do
      before do
        Sunspot.commit
        dispatch(search: currency.name)
      end

      it { expect(subject['result'].size).to eq(1) }
    end

    context 'when searching nonexistent currency' do
      before do
        Sunspot.commit
        dispatch(search: user.email)
      end

      it { expect(subject['result'].size).to eq(0) }
    end
  end

  describe 'GET /currencies/:id' do
    def dispatch
      get :show, id: currency.id
    end

    before { dispatch }

    it { expect(subject['result']['name']).to            eq(currency.name) }
    it { expect(subject['result']['code']).to            eq(currency.code) }
    it { expect(subject['result']['weight']).to          eq(currency.weight.to_s) }
    it { expect(subject['result']['collector_value']).to eq(currency.collector_value.to_s) }
    it { expect(subject['result']['country_id']).to      eq(country.code) }
  end

  describe 'POST /countries/status/:id' do
    def dispatch
      get :status, id: currency.code
    end

    context 'when currencies collected' do
      before do
        country_user.update_attributes(visited: true)
        dispatch
      end

      it { expect(subject['collected']).to eq true }
    end

    context 'when currencies not collected' do
      before do 
      	country_user.update_attributes(visited: false)
      	dispatch
      end

      it { expect(subject['collected']).to eq false }
    end
  end

  describe 'POST /currencies/stats' do
    let!(:country1)      { FactoryGirl.create :country }
    let!(:country2)      { FactoryGirl.create :country }
    let!(:country3)      { FactoryGirl.create :country }
    let!(:country4)      { FactoryGirl.create :country }
    let!(:country5)      { FactoryGirl.create :country }
    let!(:currency1)     { FactoryGirl.create :currency, country: country1 }
    let!(:currency2)     { FactoryGirl.create :currency, country: country2 }
    let!(:currency3)     { FactoryGirl.create :currency, country: country3 }
    let!(:currency4)     { FactoryGirl.create :currency, country: country4 }
    let!(:currency5)     { FactoryGirl.create :currency, country: country5 }
    let!(:country_user1) { FactoryGirl.create(:country_user, country: country1, user: user, visited: true) }
    let!(:country_user2) { FactoryGirl.create(:country_user, country: country2, user: user, visited: true) }
    let!(:country_user3) { FactoryGirl.create(:country_user, country: country3, user: user, visited: true) }
    let!(:country_user4) { FactoryGirl.create(:country_user, country: country4, user: user, visited: true) }
    let!(:country_user5) { FactoryGirl.create(:country_user, country: country5, user: user, visited: false) }

    def dispatch
      get :stats
    end

    context 'when visited country' do
      before do
        dispatch
      end

      it { expect(subject['collected']).to eq 4 }
      it { expect(subject['collected_uncollected']).to eq 2.0 }
    end
  end
end
