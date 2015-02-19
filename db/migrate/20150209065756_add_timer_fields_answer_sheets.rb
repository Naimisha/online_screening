class AddTimerFieldsAnswerSheets < ActiveRecord::Migration
  def change
  	add_column :answer_sheets, :start_time, :datetime
    add_column :answer_sheets, :end_time, :datetime
  end
end
