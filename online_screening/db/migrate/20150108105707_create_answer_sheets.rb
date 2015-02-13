class CreateAnswerSheets < ActiveRecord::Migration
  def change
    create_table :answer_sheets do |t|
      t.text :answer
      t.text :result
      t.integer :score
      t.references :user, index: true
      t.timestamps null: false
    end
    add_foreign_key :answer_sheets, :users
  end
end
