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

ActiveRecord::Schema.define(version: 20171120055321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "checkouts", id: :serial, force: :cascade do |t|
    t.bigint "checkout_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone", null: false
    t.string "email"
    t.text "discount_codes"
    t.text "order_items"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shop_id"
    t.index ["checkout_id"], name: "index_checkouts_on_checkout_id", unique: true
    t.index ["shop_id"], name: "index_checkouts_on_shop_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "checkout_id"
    t.string "name"
    t.integer "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", id: :serial, force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
    t.string "region"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "twilio_accounts", force: :cascade do |t|
    t.string "subaccount_name"
    t.bigint "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shop_id"
    t.string "sid"
    t.string "auth_token"
    t.index ["shop_id"], name: "index_twilio_accounts_on_shop_id"
  end

  add_foreign_key "checkouts", "shops"
  add_foreign_key "twilio_accounts", "shops"
end
