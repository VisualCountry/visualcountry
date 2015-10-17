class CreateProfileJoinTables < ActiveRecord::Migration
  def change
    create_table :clients_profiles do |t|
      t.integer :client_id
      t.integer :profile_id
    end

    create_table :focuses_profiles do |t|
      t.integer :focus_id
      t.integer :profile_id
    end

    create_table :interests_profiles do |t|
      t.integer :interest_id
      t.integer :profile_id
    end
  end
end
