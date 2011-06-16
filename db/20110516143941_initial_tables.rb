class InitialTables < ActiveRecord::Migration
  def self.up
    create_table :video_videos do |t|
      t.string :name, :video_hash, :provider, :provider_file_id, :status, :email
      t.text :description
      t.string :category
      t.integer :end_user_id, :file_id
      t.boolean :featured, :default => false
      t.integer :moderated, :default => 0
      t.timestamps
    end
    add_index :video_videos, :email, :name => 'email'

    create_table :video_video_targets do |t|
      t.integer :video_video_id
      t.string :target
    end

    add_index :video_video_targets, :video_video_id

    
  end

  def self.down
    drop_table :video_videos
    drop_table :video_video_targets
  end
end
