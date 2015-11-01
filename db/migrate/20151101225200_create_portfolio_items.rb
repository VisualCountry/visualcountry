class CreatePortfolioItems < ActiveRecord::Migration
  def change
    create_table :portfolio_items do |t|
      t.integer :item_id
      t.text :item_type
      t.integer :profile_id

      t.timestamps
    end

    add_index :portfolio_items, :profile_id
  end
end
