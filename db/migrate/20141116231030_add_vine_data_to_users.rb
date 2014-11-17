class AddVineDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vine_email, :string
    add_column :users, :vine_password, :string
  end
end
