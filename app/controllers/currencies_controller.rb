class CurrenciesController < ApplicationController

  def index
    @search = Currency.search do
      fulltext params[:search]

      paginate :page => params[:page],  :per_page => 15
    end

    @currencies = @search.results

    respond_to do |format|
      format.json  { render :json => { :result => @currencies, :page => params[:page] } }
    end
  end

  def show
    @currency = Currency.find(params[:id])

    respond_to do |format|
      format.json  { render :json => { :result => @currency } }
    end
  end

  def status
    @status = Currency.find(params[:id]).collected?(current_user)

    respond_to do |format|
      format.json { render :json => { :collected => @status } }
    end
  end

  def stats
    @collected = Currency.collected(current_user).count
    @collected_uncollected = @collected/Currency.not_collected(current_user).count.to_f

    respond_to do |format|
      format.json  { render :json => { :collected => @collected, :collected_uncollected => @collected_uncollected } }
    end
  end
end
