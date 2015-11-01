class RemovePaperTrailTables < ActiveRecord::Migration
  def change
    drop_table :versions
    drop_table :version_associations
  end
end
