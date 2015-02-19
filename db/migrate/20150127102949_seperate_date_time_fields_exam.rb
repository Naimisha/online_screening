class SeperateDateTimeFieldsExam < ActiveRecord::Migration
  def change
  	remove_column :exams, :date_time
  	add_column :exams, :date, :date
  	add_column :exams, :time, :time
  end
end
