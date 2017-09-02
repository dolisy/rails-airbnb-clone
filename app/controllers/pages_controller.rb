class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def profile
    @user = current_user
    @review = Review.new(user: current_user)

    @requests = []
    @user.libraries.each do |library|
      library.books.each do |book|
        book.bookings.each do |booking|
          @requests << booking
        end
      end
    end
  end
end


