class AddExamRefToAnswerSheet < ActiveRecord::Migration
  def change
    add_reference :answer_sheets, :exam, index: true
    add_foreign_key :answer_sheets, :exams
  end
end
