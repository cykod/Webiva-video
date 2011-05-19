class VideoVideo < DomainModel
  belongs_to :end_user
  has_domain_file :file_id
  has_content_tags

  validates_presence_of :email

  before_create :generate_video_hash, :assign_name
  after_update :update_meta_data

  def generate_video_hash
    self.video_hash = DomainModel.generate_hash
  end

  def assign_name 
    self.name = self.file.name
  end

  def upload_video
    provider_connect 
    video = @client.video_upload(File.open(self.file.filename), :title => self.file.name, :category => 'People')
    self.provider_file_id = video.unique_id
    self.save
    return self.provider_file_id
  end

  def update_meta_data
    provider_connect 
    @client.video_update(self.provider_file_id,:title => self.name, :description => self.description, :category => 'People', :keywords => self.tags_array)
  end

  def provider_connect
    opt = Video::AdminController.module_options
    @client = YouTubeIt::Client.new(:username => opt.user_name, :password => opt.password, :dev_key => opt.developer_key)
  end

end
