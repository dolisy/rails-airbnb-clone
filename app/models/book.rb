class Book < ApplicationRecord
  belongs_to :library
  has_many :bookings

  def self.search(term)
    if term
      where('lower(title) LIKE ?', "%#{term}%").order('id DESC')
    else
      order('id DESC')
    end
  end
end
