class CreatePresses < ActiveRecord::Migration
  def change
    create_table :presses do |t|
      t.string :publication_name
      t.string :url

      t.timestamps
    end
  end
end
