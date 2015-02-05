class RemoveIntegerFromClients < ActiveRecord::Migration
  def change
    remove_column :clients, :integer
  end
end
