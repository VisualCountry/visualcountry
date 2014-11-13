class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :client_name
      t.string :url
      t.string :user_id
      t.string :integer

      t.timestamps
    end
  end
end
