class DropPictures < ActiveRecord::Migration
  def change
    drop_table :pictures
  end
end
