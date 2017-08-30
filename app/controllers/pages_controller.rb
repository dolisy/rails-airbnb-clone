class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def profile
    @user = current_user
    @review = Review.new(user: current_user)
  end

  def google_books
    @books = Book.all

    # country = params[:country] ? params[:country] : "de"

    # title = params[:title] ? "intitle:#{params[:title]}" : "the black swan"



    # Request made from Heroku server with user's IP address
    user_ip = request.remote_ip # assuming user is accessing from a valid IP address
    @books = GoogleBooks.search(params[:title], {:country => params[:country], :count => 20}, user_ip) #=> returns valid hash of results
  end
end
