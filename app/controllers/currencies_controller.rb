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

  def maximize_collections_counter
    capacity = params[:capacity].to_i
    selected_currencies = list_selected_currencies capacity, current_user


    @selected_countries = selected_currencies
      .map(&:country)
      .map(&:name)
      .each_with_object(Hash.new 0) { |word, counter| counter[word] += 1 }

    @sum_selected_currencies = selected_currencies.map(&:weight).sum

    render json: { selected_countries: @selected_countries, sum_selected_currencies: @sum_selected_currencies }
  end

  def list_selected_currencies capacity, user
    currencies_sorted_value = Currency.not_collected(user).sort_by { |currency| currency[:collector_value] }.reverse
    currencies_sorted_weight = Currency.not_collected(user).sort_by { |currency| currency[:weight] }.reverse
    selected_currencies = []
    i = 0

    while capacity >= currencies_sorted_weight.last[:weight]
      if currencies_sorted_value[i][:weight] <= capacity
        selected_currencies << currencies_sorted_value[i]
        capacity -= currencies_sorted_value[i][:weight]
      else
        i += 1
      end
    end
    selected_currencies
  end
end
