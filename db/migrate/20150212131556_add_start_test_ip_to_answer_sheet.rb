class AddStartTestIpToAnswerSheet < ActiveRecord::Migration
  def change
    add_column :answer_sheets, :start_test_ip, :string
  end
end
