class CreateTimers < ActiveRecord::Migration
  def change
    create_table :timers do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :finished
      t.integer :user_id
      t.integer :exam_id
      t.timestamps null: false
    end
    add_foreign_key :timers, :exams
    add_foreign_key :timers, :users
  end
end
