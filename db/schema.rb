# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170831132756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "attachinary_files", force: :cascade do |t|
    t.string   "attachinariable_type"
    t.integer  "attachinariable_id"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree
  end

  create_table "bookings", force: :cascade do |t|
    t.date     "pick_up_date"
    t.date     "return_date"
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.date     "checkin_date"
    t.date     "checkout_date"
    t.integer  "number_of_pick_days"
    t.index ["book_id"], name: "index_bookings_on_book_id", using: :btree
    t.index ["user_id"], name: "index_bookings_on_user_id", using: :btree
  end

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "genre"
    t.string   "author"
    t.string   "publisher"
    t.integer  "library_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "isbn"
    t.text     "description"
    t.string   "status"
    t.float    "rate"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.integer  "work_id"
    t.date     "publication_date"
    t.integer  "number_of_pages"
    t.string   "creator"
    t.string   "ean"
    t.string   "asin"
    t.string   "amazon_detail_page_url"
    t.string   "published_language"
    t.string   "original_language"
    t.string   "edition"
    t.date     "release_date"
    t.index ["library_id"], name: "index_books_on_library_id", using: :btree
    t.index ["work_id"], name: "index_books_on_work_id", using: :btree
  end

  create_table "libraries", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.index ["user_id"], name: "index_libraries_on_user_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.text     "content"
    t.integer  "stars"
    t.integer  "library_id"
    t.integer  "booking_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["booking_id"], name: "index_reviews_on_booking_id", using: :btree
    t.index ["library_id"], name: "index_reviews_on_library_id", using: :btree
    t.index ["user_id"], name: "index_reviews_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_picture_url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "token"
    t.datetime "token_expiry"
    t.boolean  "admin",                  default: false, null: false
    t.string   "google_picture_url"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "works", force: :cascade do |t|
    t.string   "isbn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "books"
  add_foreign_key "bookings", "users"
  add_foreign_key "books", "libraries"
  add_foreign_key "books", "works"
  add_foreign_key "libraries", "users"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "libraries"
  add_foreign_key "reviews", "users"
end
