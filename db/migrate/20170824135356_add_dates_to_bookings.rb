class AddDatesToBookings < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :checkin_date, :date
    add_column :bookings, :checkout_date, :date
  end
end
