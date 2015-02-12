class AddTotalMarksExams < ActiveRecord::Migration
  def change
  	add_column :exams, :total_marks, :integer
  end
end
