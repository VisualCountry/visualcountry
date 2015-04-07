class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date, index: true
    add_column :users, :ethnicity, :integer, index: true
  end
end
