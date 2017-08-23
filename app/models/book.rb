class Book < ApplicationRecord
  belongs_to :library

  has_many :bookings

  has_many :reviews, through: :bookings

  has_attachment :photo

  validates :title, presence: true
  validates :library, presence: true

  def self.search(term)
    if term
      where('lower(title) LIKE ?', "%#{term}%").order('id DESC')
    else
      order('id DESC')
    end
  end
end
