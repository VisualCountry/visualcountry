# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151018144922) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients_profiles", force: true do |t|
    t.integer "client_id"
    t.integer "profile_id"
  end

  add_index "clients_profiles", ["client_id", "profile_id"], name: "index_clients_profiles_on_client_id_and_profile_id", unique: true, using: :btree

  create_table "clients_users", force: true do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clients_users", ["client_id", "user_id"], name: "index_clients_users_on_client_id_and_user_id", unique: true, using: :btree

  create_table "contact_messages", force: true do |t|
    t.string   "name"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "vine_account"
    t.string   "instagram_account"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "focuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "focuses_profiles", force: true do |t|
    t.integer "focus_id"
    t.integer "profile_id"
  end

  add_index "focuses_profiles", ["focus_id", "profile_id"], name: "index_focuses_profiles_on_focus_id_and_profile_id", unique: true, using: :btree

  create_table "focuses_users", force: true do |t|
    t.integer  "focus_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "focuses_users", ["focus_id", "user_id"], name: "index_focuses_users_on_focus_id_and_user_id", using: :btree

  create_table "influencer_lists", force: true do |t|
    t.string   "name",       null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  add_index "influencer_lists", ["user_id"], name: "index_influencer_lists_on_user_id", using: :btree

  create_table "interests", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interests_profiles", force: true do |t|
    t.integer "interest_id"
    t.integer "profile_id"
  end

  create_table "interests_users", force: true do |t|
    t.integer "interest_id"
    t.integer "user_id"
  end

  create_table "list_memberships", force: true do |t|
    t.integer  "user_id",            null: false
    t.integer  "influencer_list_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
  end

  add_index "list_memberships", ["influencer_list_id"], name: "index_list_memberships_on_influencer_list_id", using: :btree
  add_index "list_memberships", ["profile_id"], name: "index_list_memberships_on_profile_id", using: :btree
  add_index "list_memberships", ["user_id"], name: "index_list_memberships_on_user_id", using: :btree

  create_table "organization_list_memberships", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "influencer_list_id", null: false
    t.integer  "organization_id",    null: false
  end

  add_index "organization_list_memberships", ["influencer_list_id"], name: "index_organization_list_memberships_on_influencer_list_id", using: :btree
  add_index "organization_list_memberships", ["organization_id"], name: "index_organization_list_memberships_on_organization_id", using: :btree

  create_table "organization_memberships", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",         null: false
    t.integer  "organization_id", null: false
    t.integer  "profile_id"
  end

  add_index "organization_memberships", ["organization_id"], name: "index_organization_memberships_on_organization_id", using: :btree
  add_index "organization_memberships", ["profile_id"], name: "index_organization_memberships_on_profile_id", using: :btree
  add_index "organization_memberships", ["user_id"], name: "index_organization_memberships_on_user_id", using: :btree

  create_table "organizations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       null: false
  end

  create_table "presses", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "profile_id"
  end

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "name"
    t.string   "city"
    t.string   "bio",                      limit: 300
    t.text     "website"
    t.integer  "instagram_follower_count"
    t.integer  "twitter_follower_count"
    t.integer  "vine_follower_count"
    t.integer  "facebook_follower_count"
    t.integer  "pinterest_follower_count"
    t.integer  "total_follower_count"
    t.integer  "gender"
    t.float    "latitude"
    t.float    "longitude"
    t.date     "birthday"
    t.integer  "ethnicity"
    t.text     "special_interests"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                       default: "", null: false
    t.string   "encrypted_password",                          default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                               default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "name"
    t.string   "city"
    t.string   "bio",                             limit: 300
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.text     "facebook_token"
    t.text     "twitter_token"
    t.text     "instagram_token"
    t.text     "pinterest_token"
    t.string   "vine_email"
    t.string   "vine_password"
    t.string   "twitter_token_secret"
    t.boolean  "admin"
    t.text     "website"
    t.text     "vine_token"
    t.integer  "cached_instagram_follower_count"
    t.integer  "cached_twitter_follower_count"
    t.integer  "cached_vine_follower_count"
    t.integer  "cached_facebook_follower_count"
    t.integer  "cached_pinterest_follower_count"
    t.integer  "total_follower_count"
    t.datetime "facebook_token_expiration"
    t.integer  "gender"
    t.text     "twitter_uid"
    t.float    "latitude"
    t.float    "longitude"
    t.date     "birthday"
    t.integer  "ethnicity"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text     "special_interests"
    t.text     "facebook_uid"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
