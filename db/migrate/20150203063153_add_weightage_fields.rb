class AddWeightageFields < ActiveRecord::Migration
  def change
  	remove_column :exams, :no_of_questions
   	add_column :exams, :no_weightages, :string
  	add_column :exams, :weightages, :string
  	add_column :exams, :no_questions_each_weightage, :string
  end
end
