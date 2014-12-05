class AddDetailsToCurrency < ActiveRecord::Migration
  def change
    add_column :currencies, :weight, :decimal
    add_column :currencies, :collector_value, :decimal
  end
end
