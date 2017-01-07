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

ActiveRecord::Schema.define(version: 20170107200158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arguments", force: :cascade do |t|
    t.boolean  "agree",                null: false
    t.integer  "subject_statement_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "subject_premise_id"
    t.datetime "published_at"
    t.integer  "user_id"
    t.integer  "parent_argument_id"
    t.string   "uuid"
    t.index ["uuid"], name: "index_arguments_on_uuid", unique: true, using: :btree
  end

  create_table "premises", force: :cascade do |t|
    t.integer  "statement_id", null: false
    t.integer  "argument_id",  null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "uuid"
    t.index ["uuid"], name: "index_premises_on_uuid", unique: true, using: :btree
  end

  create_table "stances", force: :cascade do |t|
    t.integer "user_id",      null: false
    t.integer "statement_id", null: false
    t.boolean "agree"
  end

  create_table "statements", force: :cascade do |t|
    t.string   "text"
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "countered_argument_id"
    t.string   "uuid"
    t.boolean  "top_level",             default: false, null: false
    t.index ["uuid"], name: "index_statements_on_uuid", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "argument_id", null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
  end

  add_foreign_key "arguments", "arguments", column: "parent_argument_id"
  add_foreign_key "arguments", "premises", column: "subject_premise_id"
  add_foreign_key "arguments", "statements", column: "subject_statement_id"
  add_foreign_key "arguments", "users"
  add_foreign_key "premises", "arguments"
  add_foreign_key "premises", "statements"
  add_foreign_key "stances", "statements"
  add_foreign_key "stances", "users"
  add_foreign_key "statements", "arguments", column: "countered_argument_id"
  add_foreign_key "votes", "arguments"
  add_foreign_key "votes", "users"
end
