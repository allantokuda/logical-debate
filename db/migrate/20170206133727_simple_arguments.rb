class SimpleArguments < ActiveRecord::Migration[5.0]
  def up
    # add_column :arguments, :text, :string

    Argument.all.each do |argument|
      argument.update(text: argument.premises.map(&:text).join(' '))
    end

    remove_column  :arguments, :subject_premise_id, :integer

    drop_table "premises", force: :cascade do |t|
      t.integer  "statement_id", null: false
      t.integer  "argument_id",  null: false
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
      t.string   "uuid"
      t.index ["uuid"], name: "index_premises_on_uuid", unique: true, using: :btree
    end
  end

  def down
    create_table "premises", force: :cascade do |t|
      t.integer  "statement_id", null: false
      t.integer  "argument_id",  null: false
      t.datetime "created_at",   null: false
      t.datetime "updated_at",   null: false
      t.string   "uuid"
      t.index ["uuid"], name: "index_premises_on_uuid", unique: true, using: :btree
    end

    add_column  :arguments, :subject_premise_id, :integer

    # Recreate with just one premise per argument (best effort)
    Argument.all.each do |argument|
      premise = argument.premises.build(statement: Statement.new(text: argument.text.presence || '(no comment)', user: argument.user, verified_one_sentence: '1'))
      premise.save
    end

    # drop_column :arguments, :text, :string
  end
end
