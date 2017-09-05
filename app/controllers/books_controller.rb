require 'googlebooks'

class BooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]

  def index
    @books = Book.all
    @libraries = Library.all
    @users = User.all

    unless params[:location] == ''
      @books = Book.near(params[:location],200)
      @libraries = Library.near(params[:location],200)
    end

    filtering_params(params).each do |key, value|
      @books = @books.public_send(key, value)
      @libraries = @libraries.public_send(key, value)
      @users = @users.public_send(key, value)
    end

    @other_books = []

    @users.each do |user|
      user.libraries.each do |library|
        library.books.each do |book|
          @other_books << book
        end
      end
    end

    @libraries.each do |library|
      library.books.each do |book|
        @other_books << book
      end
    end

    @books.each do |book|
      @other_books << book
    end
    @other_books = @other_books.uniq
    @books = @other_books

    if params[:sort_by] == 'sort by'
      @books = @books.sort_by { |b| - b.id }
    elsif params[:sort_by] == 'title'
      @books = @books.sort_by { |b| - b.title }
    elsif params[:sort_by] == 'author'
      @books = @books.sort_by { |b| - b.author }
    elsif params[:sort_by] == 'isbn'
      @books = @books.sort_by { |b| - b.isbn }
    elsif params[:sort_by] == 'published language'
      @books = @books.sort_by { |b| - b.published_language }
    elsif params[:sort_by] == 'rating'
      @books = @books.sort_by { |b| b.rating }
    elsif params[:sort_by] == 'reviews'
      @books = @books.sort_by { |b| - b.reviews_count }
    elsif params[:sort_by] == 'curated in'
      @books = @books.sort_by { |b| - b.library.name }
    elsif params[:sort_by] == 'curated by'
      @books = @books.sort_by { |b| - b.library.user.email }
    else
      @books = @books.sort_by { |b| - b.id }
    end
    # #for libraries search
    # unless params[:location] == ''
    #   @libraries = Library.near(params[:location],200)
    # end

    # filtering_params(params).each do |key, value|
    #   @libraries = @libraries.public_send(key, value)
    # end

    # if params[:sort_by] == 'all'
    #   @libraries = @libraries.order('')
    # elsif params[:sort_by] == 'rating'
    #   @libraries = @libraries.sort_by { |b| -b.rating }
    # elsif params[:sort_by] == 'library'
    #   @libraries = @libraries.sort_by { |b| -b.library.name }
    # else
    #   @libraries = @libraries.order(params[:sort_by])
    # end



    # if params[:sort_by] == 'all'
    #   @books = @books.order('')
    # elsif params[:sort_by] == 'rating'
    #   @books = @books.sort_by { |b| -b.rating }
    # elsif params[:sort_by] == 'library'
    #   @books = @books.sort_by { |b| -b.library.name }
    # else
    #   @books = @books.order(params[:sort_by])
    # end

    # for google maps
    @hash = Gmaps4rails.build_markers(@books) do |book, marker|
      marker.lat book.library.latitude
      marker.lng book.library.longitude
      marker.infowindow render_to_string(partial: "/books/map_box", locals: { book: book })
    end
  end

  def show
    @book = Book.find(params[:id])

    # for booking_dates
    @booking_dates = []
    @book.bookings.each do |booking|
      if booking.checkin_date && booking.checkout_date
        date = booking.checkin_date
        until date > booking.checkout_date
          @booking_dates << "#{date.year}-#{date.month}-#{date.day}"
          date += 1
        end
      end
    end

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
# FOR LIBRARY
    if params[:library_id]
      @library = Library.find(params[:library_id])
    end

# FOR BOOK

    @book = Book.new(
      library_id: params[:library_id],
      title: params[:title],
      author: params[:author],
      publisher: params[:publisher],
      publication_date: params[:publication_date],
      creator: params[:creator],
      edition: params[:edition],
      release_date: params[:release_date],
      description: params[:description],
      number_of_pages: params[:number_of_pages],
      published_language: params[:published_language],
      original_language: params[:original_language],
      isbn: params[:isbn],
      ean: params[:ean],
      asin: params[:asin],
      amazon_detail_page_url: params[:detail_page_url]
    )

    if params[:image_link]
      @book.photo_url = params[:image_link]
    end

    if params[:large_image]
      @book.photo_url = params[:large_image]
    end

    require 'asin'
    require 'openlibrary'

    # initialize
    @books = Book.all

    if params[:isbn]
      # Request made from Heroku server with user's IP address
      user_ip = request.remote_ip # assuming user is accessing from a valid IP address
      @books = GoogleBooks.search("isbn:#{params[:isbn]}", {:country => params[:country], :count => 20}, user_ip) #=> returns valid hash of results

      client = ASIN::Client.instance
      @items = client.search_keywords "#{params[:isbn]}"

      # params[:title] = ""
      # params[:author] = ""
      # params[:country] = ""
    # else
    #   # Request made from Heroku server with user's IP address
    #   user_ip = request.remote_ip # assuming user is accessing from a valid IP address
    #   @books = GoogleBooks.search("#{params[:title]} inauthor:#{params[:author]}", {:country => params[:country], :count => 10}, user_ip) #=> returns valid hash of results

    #   client = ASIN::Client.instance
    #   @items = client.search_keywords "#{params[:title]} #{params[:author]}"
    #   # @items = client.search :Keywords => "#{params[:title]} #{params[:author]}" #, :SearchIndex => :Books

      @results = Hash.new
      i = 0

      if @books
        @books.each do |book|
          result = Hash.new

          begin
            result[:image_link] = book.image_link
          rescue
          end
          begin
            result[:title] = book.title
          rescue
          end
          begin
            result[:author] = book.authors
          rescue
          end
          begin
            result[:publisher] = book.publisher
          rescue
          end
          begin
            result[:publication_date] = book.published_date
          rescue
          end
          begin
            result[:description] = book.description
          rescue
          end
          begin
            result[:isbn] = book.isbn
          rescue
          end
          begin
            result[:number_of_pages] = book.page_count
          rescue
          end
          begin
            result[:published_language] = book.language
          rescue
          end
          # result[:titles_array] = book.titles_array
          # result[:product_group] = book.print_type
          # result[:categories] = book.categories
          # result[:isbn_10] = book.isbn_10
          # result[:isbn_13] = book.isbn_13
          # result[:authors_array] = book.authors_array


          @results[i] = result
          i += 1
        end
      end

      if @items
        @items.each do |item|
          result = Hash.new

          begin
            result[:asin] = item.asin
          rescue
          end
          begin
            result[:detail_page_url] = item.detail_page_url
          rescue
          end
          begin
            result[:description] = item.editorial_reviews.editorial_review.content
          rescue
          end
          begin
            result[:author] = item.item_attributes.author
          rescue
          end
          begin
            result[:creator] = item.item_attributes.creator
          rescue
          end
          begin
            result[:ean] = item.item_attributes.ean
          rescue
          end
          begin
            result[:edition] = item.item_attributes.edition
          rescue
          end
          begin
            result[:isbn] = item.item_attributes.isbn
          rescue
          end
          begin
            result[:publication_date] = item.item_attributes.publication_date
          rescue
          end
          begin
            result[:publisher] = item.item_attributes.publisher
          rescue
          end
          begin
            result[:release_date] = item.item_attributes.release_date
          rescue
          end
          begin
            result[:title] = item.item_attributes.title
          rescue
          end
          # result[:is_link_suppressed] = item.editorial_reviews.editorial_review.is_link_suppressed
          # result[:source] = item.editorial_reviews.editorial_review.source
          # result[:binding] = item.item_attributes.binding
          # result[:brand] = item.item_attributes.brand
          # result[:ean_list_element] = item.item_attributes.ean_list.ean_list_element
          # result[:feature] = item.item_attributes.feature
          # result[:item_dimensions_height] = item.item_attributes.item_dimensions.height
          # result[:item_dimensions_length] = item.item_attributes.item_dimensions.length
          # result[:item_dimensions_weight] = item.item_attributes.item_dimensions.weight
          # result[:item_dimensions_width] = item.item_attributes.item_dimensions.width
          # result[:label] = item.item_attributes.label
          # result[:amount] = item.item_attributes.list_price.amount
          # result[:currency_code] = item.item_attributes.list_price.currency_code
          # result[:formatted_price] = item.item_attributes.list_price.formatted_price
          # result[:manufacturer] = item.item_attributes.manufacturer
          # result[:mpn] = item.item_attributes.mpn
          # result[:number_of_items] = item.item_attributes.number_of_items
          # result[:number_of_pages] = item.item_attributes.number_of_pages
          # result[:package_dimensions_height] = item.item_attributes.package_dimensions.height
          # result[:package_dimensions_length] = item.item_attributes.package_dimensions.length
          # result[:package_dimensions_weight] = item.item_attributes.package_dimensions.weight
          # result[:package_dimensions_width] = item.item_attributes.package_dimensions.width
          # result[:package_quantity] = item.item_attributes.package_quantity
          # result[:part_number] = item.item_attributes.part_number
          # result[:product_group] = item.item_attributes.product_group
          # result[:product_type_name] = item.item_attributes.product_type_name
          # result[:sku] = item.item_attributes.sku
          # result[:studio] = item.item_attributes.studio

          begin
            item.image_sets.image_set.each do |element|
              begin
                result[element[0].downcase.to_sym] = element[1].url
              rescue
              end
            end
          rescue
          end

          begin
            item.item_attributes.languages.language.each do |hash|
              begin
                if hash["Type"] == "Published"
                  result[:published_language] = hash["Name"]
                elsif hash["Type"] == "Original Language"
                  result[:original_language] = hash["Name"]
                # elsif
                #   result[:unknown_language] = hash["Name"]
                end
              rescue
              end
            end
          rescue
          end

          @results[i] = result
          i += 1
        end
      end
    else
      @results = []
      params[:isbn] = ""
    end
  end

  def create
    @book = Book.new(book_params)

    if params[:library_id]
      @library = Library.find(params[:library_id])
      @book.library = @library
      @book.save
    end

    if @book.new_library_name != "" && @book.new_library_address != ""
      @library = Library.new(user: current_user, name: @book.new_library_name, address: @book.new_library_address)
      @library.save
      @book.library = @library
      @book.save
    end

    @book.address = @book.library.address

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

  private

  def book_params
    params.require(:book).permit(:title, :genre, :author, :isbn, :publisher, :description, :publication_date, :creator, :edition, :release_date, :number_of_pages, :published_language, :original_language, :new_library_name, :new_library_address, :library_id, :photo)
  end

  # list of the param names that can be used for filtering the list
  def filtering_params(params)
    params.slice(:term)
  end
end
