class CreateInfluencerLists < ActiveRecord::Migration
  def change
    create_table :influencer_lists do |t|
      t.string :name, null: false
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end
