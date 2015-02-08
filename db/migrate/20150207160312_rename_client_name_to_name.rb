class RenameClientNameToName < ActiveRecord::Migration
  def change
    rename_column :clients, :client_name, :name
  end
end
