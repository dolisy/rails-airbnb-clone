class AddAttributesToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :publication_date, :date
    add_column :books, :number_of_pages, :integer
    add_column :books, :creator, :string
    add_column :books, :ean, :string
    add_column :books, :asin, :string
    add_column :books, :amazon_detail_page_url, :string
    add_column :books, :published_language, :string
    add_column :books, :original_language, :string
    add_column :books, :edition, :string
    add_column :books, :release_date, :date
  end
end
