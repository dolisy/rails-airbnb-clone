class AddCityPostalCodeAndCountryCodeToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :city, :string
    add_column :books, :postal_code, :string
    add_column :books, :country_code, :string
  end
end
