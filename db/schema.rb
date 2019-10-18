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

ActiveRecord::Schema.define(version: 2019_10_18_193441) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_profiles", force: :cascade do |t|
    t.integer "account_id", null: false
    t.date "birthday"
    t.boolean "display_age", default: true
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
    t.date "coding_since"
    t.index ["account_id"], name: "index_account_profiles_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "role", default: 0, null: false
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "username", limit: 100
    t.string "email", limit: 255
    t.string "encrypted_password", limit: 100
    t.string "time_zone", limit: 255, default: "UTC"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_accounts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
    t.index ["role"], name: "index_accounts_on_role"
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "entries", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "type", null: false
    t.string "title", null: false
    t.string "slug"
    t.integer "comment_count", default: 0
    t.integer "vote_total", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_entries_on_slug", unique: true
    t.index ["vote_total"], name: "index_entries_on_vote_total"
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
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
