describe CountriesController, type: :controller do
  let!(:country)      { FactoryGirl.create :country }
  let!(:user)         { FactoryGirl.create :user }
  let!(:country_user) { CountryUser.find_by(user: user, country: country) }

  before do
    controller.request.headers['email'] = user.email
    controller.request.headers['auth_token'] = user.authentication_token
  end

  subject { decoded_json_response }

  describe 'GET /countries.json', :search => true do
    def dispatch parameters = {}
      get :index, parameters
    end

    before do
      Sunspot.commit
      dispatch
    end

    it { expect(subject['result'].size).to eq(1) }

    context 'when searching existing country by code' do
      before do
        Sunspot.commit
        dispatch(search: country.code)
      end

      it { expect(subject['result'].size).to eq(1) }
    end

    context 'when searching existing country by name' do
      before do
        Sunspot.commit
        dispatch(search: country.name)
      end

      it { expect(subject['result'].size).to eq(1) }
    end

    context 'when searching nonexistent country' do
      before do
        Sunspot.commit
        dispatch(search: user.email)
      end

      it { expect(subject['result'].size).to eq(0) }
    end
  end

  describe 'GET /countries/:id' do

    def dispatch
      get :show, id: country.id
    end

    before { dispatch }

    it { expect(subject['result']['name']).to eq(country.name) }
    it { expect(subject['result']['code']).to eq(country.code) }
  end

  describe 'POST /countries/:id' do
    def dispatch
      post :create, country: { name: 'Albania', code: 'al' }, visited: false
    end

    it { expect { dispatch }.to change { Country.count }.by(1).and change { CountryUser.count }.by(1) }
  end

  describe 'POST /countries/:id' do
    def dispatch
      post :update, id: country.code, country: { name: country.name, code: country.code }, visited: true
    end

    it { expect { dispatch }.to     change { country_user.reload.visited } }
    it { expect { dispatch }.not_to change { country.reload.code } }
    it { expect { dispatch }.not_to change { country.reload.name } }
  end

  describe 'POST /countries/status/:id' do
    def dispatch
      get :status, id: country.code
    end

    context 'when visited country' do
      before do
        country_user.update_attributes(visited: true)
        dispatch
      end

      it { expect(subject['visited']).to eq true }
    end

    context 'when not visited country' do
      before do 
        country_user.update_attributes(visited: false)
        dispatch
      end

      it { expect(subject['visited']).to eq false }
    end
  end

  describe 'POST /countries/stats' do
    let!(:country1)      { FactoryGirl.create :country }
    let!(:country2)      { FactoryGirl.create :country }
    let!(:country3)      { FactoryGirl.create :country }
    let!(:country4)      { FactoryGirl.create :country }
    let!(:country5)      { FactoryGirl.create :country }
    let!(:country_user1) { FactoryGirl.create(:country_user, country: country1, user: user, visited: true) }
    let!(:country_user2) { FactoryGirl.create(:country_user, country: country2, user: user, visited: true) }
    let!(:country_user3) { FactoryGirl.create(:country_user, country: country3, user: user, visited: true) }
    let!(:country_user4) { FactoryGirl.create(:country_user, country: country4, user: user, visited: true) }
    let!(:country_user5) { FactoryGirl.create(:country_user, country: country4, user: user, visited: false) }

    def dispatch
      get :stats
    end

    context 'when visited country' do
      before do
        dispatch
      end

      it { expect(subject['visited']).to eq 4 }
      it { expect(subject['visited_unvisited']).to eq 2.0 }
    end
  end
end
