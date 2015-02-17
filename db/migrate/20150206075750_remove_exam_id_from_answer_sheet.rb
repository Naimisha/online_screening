class RemoveExamIdFromAnswerSheet < ActiveRecord::Migration
  def change
    remove_column :answer_sheets, :exam_id, :integer
  end
end
