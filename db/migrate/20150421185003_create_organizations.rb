class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.timestamps

      t.string :name, null: false
    end
  end
end
