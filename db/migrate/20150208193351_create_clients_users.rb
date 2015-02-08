class CreateClientsUsers < ActiveRecord::Migration
  def change
    create_table :clients_users do |t|
      t.integer :client_id
      t.integer :user_id
      t.timestamps
    end
    add_index :clients_users, [:client_id, :user_id], :unique => true
  end
end
