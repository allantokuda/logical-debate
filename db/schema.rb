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

ActiveRecord::Schema.define(version: 20161229221846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arguments", force: :cascade do |t|
    t.boolean  "agree",                null: false
    t.integer  "subject_statement_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "subject_premise_id"
  end

  create_table "premises", force: :cascade do |t|
    t.integer  "statement_id"
    t.integer  "argument_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "statements", force: :cascade do |t|
    t.string   "text"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "arguments", "premises", column: "subject_premise_id"
  add_foreign_key "arguments", "statements", column: "subject_statement_id"
  add_foreign_key "premises", "arguments"
  add_foreign_key "premises", "statements"
end
