class CreatePhotos < ActiveRecord::Migration
  def change
    drop_table :photos
    create_table :photos do |t|
      t.string :title

      t.timestamps
    end
  end
end
