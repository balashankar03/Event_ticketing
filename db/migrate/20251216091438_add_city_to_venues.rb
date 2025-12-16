class AddCityToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :city, :string
  end
end
