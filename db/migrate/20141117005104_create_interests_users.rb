class CreateInterestsUsers < ActiveRecord::Migration
  def change
    create_table :interests_users do |t|
      t.integer :interest_id
      t.integer :user_id
    end
  end
end
