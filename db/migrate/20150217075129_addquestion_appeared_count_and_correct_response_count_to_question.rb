class AddquestionAppearedCountAndCorrectResponseCountToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :question_appeared_count, :integer, default: 0
	add_column :questions, :correct_response_count,  :integer, default: 0
  end
end
