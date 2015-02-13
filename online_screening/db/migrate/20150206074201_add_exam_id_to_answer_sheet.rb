class AddExamIdToAnswerSheet < ActiveRecord::Migration
  def change
    add_column :answer_sheets, :exam_id, :integer
  end
end
