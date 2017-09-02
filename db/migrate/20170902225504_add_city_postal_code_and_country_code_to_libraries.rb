class AddCityPostalCodeAndCountryCodeToLibraries < ActiveRecord::Migration[5.0]
  def change
    add_column :libraries, :city, :string
    add_column :libraries, :postal_code, :string
    add_column :libraries, :country_code, :string
  end
end
