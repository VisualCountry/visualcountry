class AddWebsiteToUser < ActiveRecord::Migration
  def change
    add_column :users, :website, :text
  end
end
