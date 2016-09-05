class CountriesController < ApplicationController

  def index
    @search = Country.search do
      fulltext params[:search]

      paginate :page => params[:page],  :per_page => 15
    end

    @countries = @search.results

    respond_to do |format|
      format.json  { render :json => { :result => @countries, :page => params[:page] }}
    end
  end

  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.json  { render :json => { :result => @country  } }
    end
  end

  def status
    @status = Country.find(params[:id]).visited?(current_user)

    respond_to do |format|
      format.json  { render :json => { :visited => @status } }
    end
  end

  def stats
    @visited = Country.visited(current_user).count
    @visited_unvisited = @visits/Country.not_visited(current_user).count.to_f

    respond_to do |format|
      format.json  { render :json => { :visited => @visited, :visited_unvisited => @visited_unvisited }}
    end
  end

  def edit
    @country = Country.find(params[:id])
    @country_user = CountryUser.find_by(user: current_user, country: @country)

    respond_to do |format|
      format.json  { render :json => { :country_user => @country_user, :country => @country } }
    end
  end

  def create
    @country = Country.new(params[:country].permit(:visited,:name,:code))

    respond_to do |format|
      if @country.save
        format.json  { render :json => { :result => @country, :status => :created, :location => @country } }
      else
        format.json  { render :json => { :result => @country.errors, :status => :unprocessable_entity } }
      end
    end
  end

  def update
    @country = Country.find(params[:id])

    respond_to do |format|
      if @country.update_attributes(params[:country].permit(:name,:code))
        country_user = CountryUser.find_by(user: current_user, country: @country)
        country_user.update_attributes(visited: params[:visited])
        format.json  { head :ok }
      else
        format.json  { render :xml => { :result => @country.errors, :status => :unprocessable_entity } }
      end
    end
  end
end
