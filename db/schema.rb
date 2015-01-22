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

ActiveRecord::Schema.define(version: 20150122011833) do

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

  create_table "group_memberships", force: true do |t|
    t.integer  "joined_group_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_memberships", ["joined_group_id"], name: "index_group_memberships_on_joined_group_id", using: :btree
  add_index "group_memberships", ["member_id"], name: "index_group_memberships_on_member_id", using: :btree

  create_table "group_posts", force: true do |t|
    t.integer  "group_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_posts", ["group_id"], name: "index_group_posts_on_group_id", using: :btree
  add_index "group_posts", ["post_id"], name: "index_group_posts_on_post_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "private",     default: false
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["name"], name: "index_groups_on_name", using: :btree
  add_index "groups", ["owner_id"], name: "index_groups_on_owner_id", using: :btree
  add_index "groups", ["private"], name: "index_groups_on_private", using: :btree

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
    t.string   "user_name",              default: "LOL"
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
    t.integer  "following_count",        default: 0
    t.integer  "follower_count",         default: 0
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true, using: :btree
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true, using: :btree
  add_index "members", ["slug"], name: "index_members_on_slug", using: :btree

  create_table "news_feeds", force: true do |t|
    t.integer  "member_id"
    t.integer  "write_level", default: 7
    t.text     "updates",     default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_feeds", ["member_id"], name: "index_news_feeds_on_member_id", using: :btree

  create_table "pending_friend_requests", force: true do |t|
    t.integer  "member_id"
    t.integer  "initiator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pending_friend_requests", ["initiator_id"], name: "index_pending_friend_requests_on_initiator_id", using: :btree
  add_index "pending_friend_requests", ["member_id"], name: "index_pending_friend_requests_on_member_id", using: :btree

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

  create_table "recently_viewed_recipes", force: true do |t|
    t.integer  "member_id"
    t.text     "recently_viewed_list", default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recently_viewed_recipes", ["member_id"], name: "index_recently_viewed_recipes_on_member_id", using: :btree

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
    t.float    "cached_rating",           default: 0.0
    t.integer  "num_reviews",             default: 0
    t.integer  "global_views",            default: 0
    t.decimal  "trend_level",             default: 0.0
    t.boolean  "private",                 default: false
  end

  add_index "recipes", ["cached_rating"], name: "index_recipes_on_cached_rating", using: :btree
  add_index "recipes", ["global_views"], name: "index_recipes_on_global_views", using: :btree
  add_index "recipes", ["num_reviews"], name: "index_recipes_on_num_reviews", using: :btree
  add_index "recipes", ["private"], name: "index_recipes_on_private", where: "(private = false)", using: :btree
  add_index "recipes", ["trend_level"], name: "index_recipes_on_trend_level", using: :btree

  create_table "recipes_tags", force: true do |t|
    t.integer "recipe_id"
    t.integer "tag_id"
  end

  add_index "recipes_tags", ["recipe_id", "tag_id"], name: "index_recipes_tags_on_recipe_id_and_tag_id", unique: true, using: :btree
  add_index "recipes_tags", ["recipe_id"], name: "index_recipes_tags_on_recipe_id", using: :btree
  add_index "recipes_tags", ["tag_id", "recipe_id"], name: "index_recipes_tags_on_tag_id_and_recipe_id", unique: true, using: :btree
  add_index "recipes_tags", ["tag_id"], name: "index_recipes_tags_on_tag_id", using: :btree

  create_table "recommendations", force: true do |t|
    t.integer  "member_id"
    t.text     "recs_list",  default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommendations", ["member_id"], name: "index_recommendations_on_member_id", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "rating",             default: 1
    t.text     "rating_text",        default: ""
    t.text     "suggestions",        default: ""
    t.integer  "reviewed_recipe_id"
    t.integer  "reviewer_id"
    t.integer  "helpful_count"
    t.boolean  "pending",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["reviewed_recipe_id"], name: "index_reviews_on_reviewed_recipe_id", using: :btree
  add_index "reviews", ["reviewer_id"], name: "index_reviews_on_reviewer_id", using: :btree

  create_table "suggestions", force: true do |t|
    t.integer  "who_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_hits", force: true do |t|
    t.integer  "member_id"
    t.integer  "views",                   default: 0
    t.integer  "chinese_count",           default: 0
    t.integer  "american_count",          default: 0
    t.integer  "hack_count",              default: 0
    t.integer  "easy_count",              default: 0
    t.integer  "average_count",           default: 0
    t.integer  "difficult_count",         default: 0
    t.integer  "lazy_count",              default: 0
    t.decimal  "chinese_count_percent",   default: 0.0
    t.decimal  "american_count_percent",  default: 0.0
    t.decimal  "hack_count_percent",      default: 0.0
    t.decimal  "easy_count_percent",      default: 0.0
    t.decimal  "average_count_percent",   default: 0.0
    t.decimal  "difficult_count_percent", default: 0.0
    t.decimal  "lazy_count_percent",      default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tag_hits", ["member_id"], name: "index_tag_hits_on_member_id", using: :btree

  create_table "tag_types", force: true do |t|
    t.string   "name"
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
