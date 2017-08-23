# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "cleaning..."

# User.destroy_all
Review.destroy_all
Booking.destroy_all
Book.destroy_all
Library.destroy_all




puts "creating 5 users..."
(0..5).to_a.each do
  user = User.new(email: Faker::Internet.email, password: Faker::Internet.password(8))
  user.save!
end

puts "creating 20 libraries..."
(0..20).to_a.each do
  library = Library.new(name: Faker::Address.city, user: User.all.order('RANDOM()').first())
  library.save!
end

puts "creating 30 books..."
(0..30).to_a.each do
  book = Book.new(title: Faker::Book.title, genre: Faker::Book.genre, author: Faker::Book.author, publisher: Faker::Book.publisher, description: Faker::Lorem.paragraph, library: Library.all.order('RANDOM()').first(), status: 'active')
  book.save!
end


puts "creating 50 bookings..."
(0..40).to_a.each do
  booking = Booking.new(pick_up_date: Faker::Date.backward(14), return_date: Faker::Date.forward(23), user: User.all.order('RANDOM()').first(), book: Book.all.order('RANDOM()').first())
  booking.save!
end

puts "creating 80 reviews..."
(0..40).to_a.each do
  review = Review.new(content: Faker::Lorem.paragraph, stars: Random.rand(5), user: User.all.order('RANDOM()').first(), booking: Booking.all.order('RANDOM()').first())
  review.save!
end
