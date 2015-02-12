class CreateFocusesUsers < ActiveRecord::Migration
  def change
    create_table :focuses_users do |t|
      t.integer :focus_id
      t.integer :user_id

      t.timestamps
    end

    add_index :focuses_users, [:focus_id, :user_id]
  end
end
