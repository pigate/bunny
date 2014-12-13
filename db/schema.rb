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

ActiveRecord::Schema.define(version: 20141212195709) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boxes", force: true do |t|
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "comment_text"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "commenter_id",     default: -1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "convos", force: true do |t|
    t.integer  "conversable_id"
    t.string   "conversable_type"
    t.integer  "write_access_level", default: 2
    t.integer  "owner_id",           default: -1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hearts", force: true do |t|
    t.integer  "liked_recipe_id"
    t.integer  "liker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hearts", ["liked_recipe_id"], name: "index_hearts_on_liked_recipe_id", using: :btree
  add_index "hearts", ["liker_id"], name: "index_hearts_on_liker_id", using: :btree

  create_table "liked_rxps", force: true do |t|
    t.integer  "liked_recipe_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "liked_rxps", ["liked_recipe_id"], name: "index_liked_rxps_on_liked_recipe_id", using: :btree

  create_table "members", force: true do |t|
    t.string   "first"
    t.string   "last"
    t.string   "user_name"
    t.string   "occupation"
    t.boolean  "admin",                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "slug"
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree
  add_index "members", ["slug"], name: "index_members_on_slug", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "author_id"
    t.text     "post_text"
    t.text     "s_tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.text     "about",                   default: ""
    t.text     "ingreds"
    t.text     "steps"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "j_ingreds"
    t.text     "j_steps"
    t.integer  "prep_time",               default: 10
    t.integer  "cook_time",               default: 10
    t.integer  "servings",                default: 3
    t.string   "main_photo_file_name"
    t.string   "main_photo_content_type"
    t.integer  "main_photo_file_size"
    t.datetime "main_photo_updated_at"
    t.text     "s_tags",                  default: ""
  end

  create_table "suggestions", force: true do |t|
    t.integer  "who_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "approved",     default: false
    t.integer  "submitter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.integer  "tag_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",        default: 0
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
