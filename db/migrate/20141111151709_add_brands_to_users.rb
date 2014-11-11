class AddBrandsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :brands, :string
  end
end
