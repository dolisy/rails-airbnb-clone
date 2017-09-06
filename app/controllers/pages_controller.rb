class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def profile
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end

    @libraries = @user.libraries

    @books = []
    @libraries.each do |library|
      library.books.each do |book|
        @books << book
      end
    end

    @requests = []
    @books.each do |book|
      book.bookings.each do |booking|
        @requests << booking
      end
    end

    @bookings = @user.bookings

    @review = Review.new(user: @user)
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

  def view_all_libraries
    @libraries = Library.all

    # for google maps
    @hash = Gmaps4rails.build_markers(@libraries) do |library, marker|
      marker.lat library.latitude
      marker.lng library.longitude
      marker.infowindow render_to_string(partial: "/libraries/map_box", locals: { library: library })
    end
  end

  private

  def user_params
    params.require(:user_id).permit(:first_name, :last_name, :email)
  end
end


