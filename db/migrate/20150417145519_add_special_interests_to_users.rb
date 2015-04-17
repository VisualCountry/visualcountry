class AddSpecialInterestsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :special_interests, :text
  end
end
