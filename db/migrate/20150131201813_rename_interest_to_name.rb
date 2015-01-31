class RenameInterestToName < ActiveRecord::Migration
  def change
    rename_column :interests, :interest, :name
  end
end
