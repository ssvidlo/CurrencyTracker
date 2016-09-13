class CurrenciesController < ApplicationController

  def index
    @search = Currency.search do
      fulltext params[:search]

      paginate page: params[:page],  per_page: 15
    end

    @currencies = @search.results

   render json: { result: @currencies, page: params[:page] }
  end

  def show
    @currency = Currency.find(params[:id])

    render json: { result: @currency }
  end

  def status
    @status = Currency.find(params[:id]).collected?(current_user)

    render json: { collected: @status }
  end

  def stats
    @collected = Currency.collected(current_user).count
    @collected_uncollected = @collected/Currency.not_collected(current_user).count.to_f

    render json: { collected: @collected, collected_uncollected: @collected_uncollected }
  end
end
