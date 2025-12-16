# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_12_16_091438) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_events", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "event_id", null: false
    t.index ["category_id", "event_id"], name: "index_categories_events_on_category_id_and_event_id"
    t.index ["event_id", "category_id"], name: "index_categories_events_on_event_id_and_category_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "datetime"
    t.bigint "venue_id", null: false
    t.bigint "organizer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "amount"
    t.string "status"
    t.bigint "event_id", null: false
    t.bigint "participant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_orders_on_event_id"
    t.index ["participant_id"], name: "index_orders_on_participant_id"
  end

  create_table "organizers", force: :cascade do |t|
    t.string "website"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "participants", force: :cascade do |t|
    t.date "date_of_birth"
    t.string "city"
    t.string "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_tiers", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.boolean "available"
    t.integer "remaining"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_ticket_tiers_on_event_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "serial_no"
    t.string "seat_info"
    t.bigint "order_id", null: false
    t.bigint "ticket_tier_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_tickets_on_order_id"
    t.index ["ticket_tier_id"], name: "index_tickets_on_ticket_tier_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "userable_type", null: false
    t.bigint "userable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["userable_type", "userable_id"], name: "index_users_on_userable"
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "city"
  end

  add_foreign_key "events", "organizers"
  add_foreign_key "events", "venues"
  add_foreign_key "orders", "events"
  add_foreign_key "orders", "participants"
  add_foreign_key "ticket_tiers", "events"
  add_foreign_key "tickets", "orders"
  add_foreign_key "tickets", "ticket_tiers"
end
