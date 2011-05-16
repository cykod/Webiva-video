class InitialTables < ActiveRecord::Migration
  def self.up
    create_table :video_videos do |t|
      t.string :name, :video_hash, :provider, :provider_file_id, :status, :email
      t.text :description
      t.integer :end_user_id, :file_id
      t.boolean :featured, :default => false
      t.timestamps
    end
    add_index :video_videos, :email, :name => 'email'
  end

  def self.down
    drop_table :video_videos
  end
end
