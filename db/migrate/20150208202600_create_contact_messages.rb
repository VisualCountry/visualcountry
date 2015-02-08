class CreateContactMessages < ActiveRecord::Migration
  def change
    create_table :contact_messages do |t|
      t.string :name
      t.string :email_address
      t.string :phone_number
      t.string :vine_account
      t.string :instagram_account
      t.text :body

      t.timestamps
    end
  end
end
