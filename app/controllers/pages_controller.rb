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

  def view_all_books
    @books = Book.all

    # for google maps
    @hash = Gmaps4rails.build_markers(@books) do |book, marker|
      marker.lat book.library.latitude
      marker.lng book.library.longitude
      marker.infowindow render_to_string(partial: "/books/map_box", locals: { book: book })
    end
  end
end


