class CreateYoutubeVideos < ActiveRecord::Migration
  def change
    create_table :youtube_videos do |t|
      t.text :guid
      t.text :source

      t.timestamps
    end
  end
end
