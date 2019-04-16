# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_16_144837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_profiles", force: :cascade do |t|
    t.integer "account_id", null: false
    t.date "birthday"
    t.boolean "display_birthday", default: true
    t.string "location"
    t.json "latlon"
    t.string "bio", limit: 255
    t.string "website_url"
    t.string "employer_name"
    t.string "employment_title"
    t.string "employer_url"
    t.string "twitter_username"
    t.string "github_username"
    t.string "facebook_url"
    t.string "linkedin_url"
    t.string "stackoverflow_url"
    t.string "dribbble_url"
    t.string "medium_url"
    t.string "behance_url"
    t.string "gitlab_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id"], name: "index_account_profiles_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "type", limit: 255
    t.integer "role", default: 0, null: false
    t.string "first_name", limit: 255, null: false
    t.string "last_name", limit: 255, null: false
    t.string "username", limit: 100
    t.string "email", limit: 255
    t.string "new_email", limit: 255
    t.string "email_confirmation_digest", limit: 100
    t.datetime "email_confirmation_sent_at"
    t.string "password_digest", limit: 100
    t.string "remember_digest", limit: 100
    t.string "activation_digest", limit: 100
    t.boolean "activated", default: false, null: false
    t.datetime "activated_at"
    t.string "reset_digest", limit: 100
    t.datetime "reset_sent_at"
    t.string "time_zone", limit: 255, default: "UTC"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email", "new_email"], name: "index_accounts_on_email_and_new_email", unique: true
    t.index ["role"], name: "index_accounts_on_role"
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followee_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followee_id"], name: "index_relationships_on_followee_id"
    t.index ["follower_id", "followee_id"], name: "index_relationships_on_follower_id_and_followee_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  add_foreign_key "account_profiles", "accounts", on_update: :cascade, on_delete: :cascade
end
