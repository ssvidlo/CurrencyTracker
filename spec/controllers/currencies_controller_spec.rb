describe CurrenciesController, type: :controller do
  let!(:country) { FactoryGirl.create :country }
  let!(:currency) { FactoryGirl.create(:currency, country: country) }
  let!(:user) { FactoryGirl.create :user }
  let!(:country_user) { CountryUser.find_by(user: user, country: country) }

  before { controller.stub(:current_user) { user } }

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

    it { expect(subject['result']['name']).to eq(currency.name) }
    it { expect(subject['result']['code']).to eq(currency.code) }
    it { expect(subject['result']['weight']).to eq(currency.weight.to_s) }
    it { expect(subject['result']['collector_value']).to eq(currency.collector_value.to_s) }
    it { expect(subject['result']['country_id']).to eq(country.code) }
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
    let!(:country1)      { FactoryGirl.create(:country, name: 'Albania', code: 'al') }
    let!(:country2)      { FactoryGirl.create(:country, name: 'Algeria', code: 'dz') }
    let!(:country3)      { FactoryGirl.create(:country, name: 'American Samoa', code: 'as') }
    let!(:country4)      { FactoryGirl.create(:country, name: 'Argentina', code: 'ar') }
    let!(:country5)      { FactoryGirl.create(:country, name: 'Angola', code: 'ao') }
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
    let! :currency4 do
      FactoryGirl.create :currency,
      name: 'Birr',
      code: 'ETB',
      weight: '2.41315872644931',
      collector_value: '8.96192605938152',
      country: country4
    end
    let! :currency5 do
      FactoryGirl.create :currency,
      name: 'New Kwanza',
      code: 'AON',
      weight: '3.58570369163788',
      collector_value: '7.81741384733311',
      country: country5
    end
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
