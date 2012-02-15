class Nameandcity < ActiveRecord::Migration
  def self.up
    add_column :video_videos, :recipient, :string
    add_column :video_videos, :state, :string
  end

  def self.down
    remove_column :video_videos, :recipient
    remove_column :video_videos, :state
  end
end
