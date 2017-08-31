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
    require 'openlibrary'

    # initialize
    @books = Book.all



    if params[:isbn] != ""
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
    end

    @results = Hash.new
    i = 0

    if @books
      @books.each do |book|
        result = Hash.new

        result[:image_link] = book.image_link
        result[:title] = book.title
        # result[:titles_array] = book.titles_array
        result[:author] = book.authors
        # result[:authors_array] = book.authors_array
        result[:publisher] = book.publisher
        result[:publication_date] = book.published_date
        result[:description] = book.description
        result[:isbn] = book.isbn
        # result[:isbn_10] = book.isbn_10
        # result[:isbn_13] = book.isbn_13
        result[:number_of_pages] = book.page_count
        # result[:product_group] = book.print_type
        # result[:categories] = book.categories
        result[:published_language] = book.language

        @results[i] = result
        i += 1
      end
    end

    if @items
      @items.each do |item|
        result = Hash.new

        result[:asin] = item.asin
        result[:detail_page_url] = item.detail_page_url
        result[:description] = item.editorial_reviews.editorial_review.content
        # result[:is_link_suppressed] = item.editorial_reviews.editorial_review.is_link_suppressed
        # result[:source] = item.editorial_reviews.editorial_review.source
        result[:author] = item.item_attributes.author
        # result[:binding] = item.item_attributes.binding
        # result[:brand] = item.item_attributes.brand
        result[:creator] = item.item_attributes.creator
        result[:ean] = item.item_attributes.ean
        # result[:ean_list_element] = item.item_attributes.ean_list.ean_list_element
        result[:edition] = item.item_attributes.edition
        # result[:feature] = item.item_attributes.feature
        result[:isbn] = item.item_attributes.isbn
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
        result[:publication_date] = item.item_attributes.publication_date
        result[:publisher] = item.item_attributes.publisher
        result[:release_date] = item.item_attributes.release_date
        # result[:sku] = item.item_attributes.sku
        # result[:studio] = item.item_attributes.studio
        result[:title] = item.item_attributes.title

        item.image_sets.image_set.each do |element|
          begin
            result[element[0].downcase.to_sym] = element[1].url
          rescue
          end
        end

        item.item_attributes.languages.language.each do |hash|
          if hash["Type"] == "Published"
            result[:published_language] = hash["Name"]
          elsif hash["Type"] == "Original Language"
            result[:original_language] = hash["Name"]
          # elsif
          #   result[:unknown_language] = hash["Name"]
          end
        end

        @results[i] = result
        i += 1
      end
    end
  end
end


