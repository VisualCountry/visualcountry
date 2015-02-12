class CreateFocuses < ActiveRecord::Migration
  def change
    create_table :focuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
