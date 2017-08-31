class AddNumberOfPagesToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :number_of_pages, :string
  end
end
