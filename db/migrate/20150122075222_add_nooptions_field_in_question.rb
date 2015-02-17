class AddNooptionsFieldInQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :nooptions, :integer
  end
end
