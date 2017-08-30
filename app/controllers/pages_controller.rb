class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def profile
    @user = current_user
    @review = Review.new(user: current_user)
  end

  def google_books
    require 'asin'
    @books = Book.all



    # Request made from Heroku server with user's IP address
    user_ip = request.remote_ip # assuming user is accessing from a valid IP address

    if params[:isbn] != ""
      @books = GoogleBooks.search("isbn:#{params[:isbn]}", {:country => params[:country], :count => 20}, user_ip) #=> returns valid hash of results

      client = ASIN::Client.instance
      @items = client.search_keywords "#{params[:isbn]}"

      params[:title] = ""
      params[:author] = ""
      params[:country] = ""
    else
      @books = GoogleBooks.search("#{params[:title]} inauthor:#{params[:author]}", {:country => params[:country], :count => 10}, user_ip) #=> returns valid hash of results

      client = ASIN::Client.instance
      @items = client.search_keywords "#{params[:title]} #{params[:author]}"
      # @items = client.search :Keywords => "#{params[:title]} #{params[:author]}" #, :SearchIndex => :Books
    end


    # Amazon Books
    # just require

    # # create an ASIN client
    # client = ASIN::Client.instance

    # # lookup an item with the amazon standard identification number (asin)
    # items = client.lookup '1430218150'

    # # have a look at the title of the item
    # items.first.item_attributes.title
    # # => Learn Objective-C on the Mac (Learn Series)

    # # search for any kind of stuff on amazon with keywords
    # items = client.search_keywords 'Learn', 'Objective-C'
    # items.first.item_attributes.title
    # # => "Learn Objective-C on the Mac (Learn Series)"

    # # search for any kind of stuff on amazon with custom parameters
    # items = client.search :Keywords => 'Learn Objective-C', :SearchIndex => :Books
    # items.first.item_attributes.title
    # # => "Learn Objective-C on the Mac (Learn Series)"

    # # search for similar items like the one you already have
    # items = client.similar '1430218150'
    # items.first.item_attributes.title
    # # => "Beginning iOS 7 Development: Exploring the iOS SDK"

  end
end
