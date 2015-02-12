class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
    	t.datetime :date_time
    	t.integer :duration_mins
    	t.integer :no_of_questions
    	t.string :college_name

      t.timestamps null: false
    end
  end
end
