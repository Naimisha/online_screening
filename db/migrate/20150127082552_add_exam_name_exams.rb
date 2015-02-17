class AddExamNameExams < ActiveRecord::Migration
  def change
  	add_column :exams, :exam_name, :string
  end
end
