class CreateCountryUsers < ActiveRecord::Migration
  def change
    create_table :country_users do |t|
      t.integer  :user_id
      t.string   :country_id
      t.boolean  :visited, :default => false

      t.timestamps
    end

    remove_column :countries, :visited, :boolean
  end
end
