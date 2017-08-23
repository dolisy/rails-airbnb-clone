require 'googlebooks'

class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @books = Book.search(params[:term])


    @hash = Gmaps4rails.build_markers(@books) do |book, marker|
    marker.lat book.library.latitude
    marker.lng book.library.longitude
    marker.infowindow render_to_string(partial: "/books/map_box", locals: { book: book })
    end
    @search = params[:term]

  end

  def show
    @book = Book.find(params[:id])

    #show map
    @hash = Gmaps4rails.build_markers(@book) do |book, marker|
    marker.lat book.library.latitude
    marker.lng book.library.longitude
    end


    # for New Booking Form
    @user = current_user
    @booking = Booking.new

    # for Google Books Cover
    @book_cover = begin
      GoogleBooks.search("isbn:#{@book.isbn}").first.image_link
    rescue

    end
  end

  def new
    @book = Book.new

    @search = ''
    @book_search = GoogleBooks.search('#{@search}')
  end

  def create
    @book = Book.new(book_params)
    @book.save

    redirect_to book_path(@book)
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    @book.update(book_params)

    redirect_to book_path(@book)
  end

  def book_params
    params.require(:book).permit(:title, :genre, :author, :publisher, :library_id, :term, :photo)
  end
end
