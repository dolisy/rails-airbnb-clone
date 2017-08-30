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

    # Google Books

    # Request made from Heroku server with user's IP address
    user_ip = request.remote_ip # assuming user is accessing from a valid IP address

    if params[:isbn] != ""
      @books = GoogleBooks.search("isbn:#{params[:isbn]}", {:country => params[:country], :count => 20}, user_ip) #=> returns valid hash of results
      params[:title] = @books.first.title
      params[:author] = @books.first.authors
      params[:country] = ""
    else
      @books = GoogleBooks.search("#{params[:title]} inauthor:#{params[:author]}", {:country => params[:country], :count => 10}, user_ip) #=> returns valid hash of results
    end


    # Amazon Books

    # Default options:
    #  options[:version] => "2013-08-01"
    #  options[:service] => "AWSECommerceService"
    Amazon::Ecs.configure do |options|
      options[:AWS_access_key_id] = '[ENV['AWS_ACCESS_KEY_ID']]'
      options[:AWS_secret_key] = '[ENV['']]'
      options[:associate_tag] = '[ENV['']]'
    end

    @res = Amazon::Ecs.item_search('ruby')




  end
end
