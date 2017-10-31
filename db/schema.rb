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

ActiveRecord::Schema.define(version: 20171031230753) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "checkouts", force: :cascade do |t|
    t.bigint   "checkout_id",    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone",          null: false
    t.string   "email"
    t.text     "discount_codes"
    t.text     "order_items"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "shop_id"
    t.index ["checkout_id"], name: "index_checkouts_on_checkout_id", unique: true, using: :btree
    t.index ["shop_id"], name: "index_checkouts_on_shop_id", using: :btree
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true, using: :btree
  end

  add_foreign_key "checkouts", "shops"
end
