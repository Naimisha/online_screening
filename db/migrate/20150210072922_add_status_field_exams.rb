class AddStatusFieldExams < ActiveRecord::Migration
  def change
  	add_column :exams, :status, :string
  	add_column :exams, :start_window_time, :time
  	add_column :exams, :end_window_time, :time
  end
end
