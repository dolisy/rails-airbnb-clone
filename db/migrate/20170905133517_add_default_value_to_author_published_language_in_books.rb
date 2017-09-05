class AddDefaultValueToAuthorPublishedLanguageInBooks < ActiveRecord::Migration[5.0]
  def change
    change_column :books, :author, :string, :default => "no author"
    change_column :books, :published_language, :string, :default => "no published_language"
  end
end
