class AddNotesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :notes, :text
  end
end
