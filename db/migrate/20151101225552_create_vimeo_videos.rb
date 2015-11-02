class CreateVimeoVideos < ActiveRecord::Migration
  def change
    create_table :vimeo_videos do |t|
      t.text :guid
      t.text :source

      t.timestamps
    end
  end
end
