class CountriesController < ApplicationController

  def index
    @search = Country.search do
      fulltext params[:search]

      paginate page: params[:page],  per_page: 15
    end

    @countries = @search.results
    render json: { result: @countries }
  end

  def show
    @country = Country.find(params[:id])

    render json: { result: @country }
  end

  def status
    @status = Country.find(params[:id]).visited?(current_user)

    render json: { visited: @status }
  end

  def stats
    @visited = Country.visited(current_user).count
    @visited_unvisited = @visited/Country.not_visited(current_user).count.to_f

    render json:  { visited: @visited, visited_unvisited: @visited_unvisited }
  end

  def edit
    @country = Country.find(params[:id])
    @country_user = CountryUser.find_by(user: current_user, country: @country)

    render json: { country_user: @country_user, country: @country }
  end

  def create
    @country = Country.new(params[:country].permit(:name,:code))

    if @country.save
      country_user = CountryUser.find_or_create_by(user: current_user, country: @country)
      country_user.update_attributes(visited: params[:visited])
      render json: { result: @country, status: :created, location: @country }
    else
      render json: { result: @country.errors, status: :unprocessable_entity }
    end
  end

  def update
    @country = Country.find(params[:id])

    if @country.update_attributes(params[:country].permit(:name,:code))
      country_user = CountryUser.find_by(user: current_user, country: @country)
      country_user.update_attributes(visited: params[:visited])
      render json: { result: @country, status: :updated, location: @country }
    else
      render json: { result: @country.errors, status: :unprocessable_entity }
    end
  end
end
