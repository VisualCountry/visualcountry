class RenamePublicationNameToName < ActiveRecord::Migration
  def change
    rename_column :presses, :publication_name, :name
  end
end
