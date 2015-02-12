class ConvertStringToTest < ActiveRecord::Migration
  def change
  	change_column :answer_sheets, :answer, :text
  	change_column :answer_sheets, :result, :text
  	change_column :questions, :question, :text
  end
end
