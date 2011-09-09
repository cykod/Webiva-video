class VideoVideo < DomainModel
  belongs_to :end_user
  has_domain_file :file_id
  has_content_tags

  validates_presence_of :email
  validates_presence_of :terms

  before_create :generate_video_hash
  after_create :save_end_user
  after_update :update_meta_data
  after_destroy :destroy_video

  named_scope :with_end_user, lambda { |user| {:conditions => {:end_user_id=>user.id} } }
  named_scope :approved , { :conditions => ['moderated > 0'] }

  content_node :push_value => true 

  has_options :moderated, [['Unmoderated',0],['Approved',1],['Rejected',-1],['Error',-2]]

  attr_accessor :description_other
  attr_accessor :zip
  attr_accessor :receive_updates
  attr_accessor :terms

  validate_on_create :ensure_file


  named_scope(:by_category, Proc.new { |cat| 
    {:conditions => { :category => cat } }
  });

  named_scope(:by_content, Proc.new { |keyword|
    { :conditions => [ 'MATCH (content_node_values.title,content_node_values.body) AGAINST (? IN BOOLEAN MODE)',keyword ],
      :joins => { :content_node => :content_node_values }
    }
  })

  named_scope(:by_tags, Proc.new { |tags|
     tags = ContentTag.find(:all,:conditions => { :name =>  tags, :content_type => 'VideoVideo' })

     if tags.length > 0
       { :select => 'DISTINCT video_videos.*',
         :conditions => [ 'content_tag_tags.content_tag_id IN (?)',tags.map(&:id) ],
         :joins => [ :content_tag_tags ] }
     else 
        {}
     end
  })


  def self.search(page,options) 
    scope = VideoVideo.approved

    scope = scope.by_content(options[:query]) if options[:query].present?
    scope = scope.by_category(options[:category]) if options[:category].present?
    scope = scope.by_tags(options[:tags]) if options[:tags].present? && options[:tags].reject(&:blank?).length > 0

    scope.paginate(page)
  end

  def generate_video_hash
    self.video_hash = DomainModel.generate_hash
  end

  def feature
    self.update_attribute('featured',true)
  end

  def approve 
    self.update_attribute('moderated',1)
  end

  def unapprove 
    self.update_attribute('moderated',-1)
  end

  def self.category_options
    Video::AdminController.module_options.category_options
  end

  def self.top_tags
    VideoVideo.tag_cloud[0..5].map { |t| t[:name] }
  end

  def upload_video
    provider_connect         
    video = @client.video_upload(File.open(self.file.filename), :title => self.file.name, :category => 'People', :list => self.moderate_value)
    self.provider_file_id = video.unique_id
    self.provider = 'youtube'
    if(video) 
      self.file.destroy
      self.file_id = nil
    end
    self.save

    self.send_email


    return self.provider_file_id
  end

  def content_node_body(language) 
    ((self.attributes.slice('name','created_at','category','description')).values + [ self.tag_names ]).join(" ")
  end

  def content_description(language)
    "Video - %s" / self.category.to_s
  end

  def self.content_admin_url(item_id) #:nodoc:
     {:controller => '/video/manage', :action => 'edit',
      :path => [ item_id ] }
  end


  def description_option
    return '' if self.description.blank?
    if Video::AdminController.module_options.descriptions_options.include?(self.description)
      self.description
    else
      'other'
    end
  end

  def description_option=(val)
    @description_option = self.description = val unless val == 'other'
  end

  def description_other
    if Video::AdminController.module_options.descriptions_options.include?(self.description)
      ""
    else
      self.description
    end
  end

  def description_other=(val)
    self.description = val unless val.blank? || @description_option
  end

  def update_meta_data
    provider_connect 
    begin
      @client.video_update(self.provider_file_id,:title => self.name, :description => self.description, :category => 'People', :keywords => self.tags_array, :list => self.moderate_value)
    rescue Exception => e
      unless @couldnt_save
        self.update_attribute(:moderated,-2)
        @couldnt_save = true
      end
    end
  end

  def provider_connect
    opt = Video::AdminController.module_options
    @client = YouTubeIt::Client.new(:username => opt.user_name, :password => opt.password, :dev_key => opt.developer_key)
  end


  def moderate_value
    if self.moderated == 1
      return 'allowed'
    else  
      return 'denied'
    end
  end  

  def send_email
    opts = Video::AdminController.module_options
    if(opts.email_template)
      atr = self.attributes
      atr['url'] = Configuration.domain_link(SiteNode.link(opts.edit_page_url,self.id.to_s)) + "?video_hash=#{self.video_hash}"
      atr['link'] = "<a href='#{atr['url']}'>#{atr['url']}</a>"
      opts.email_template.deliver_to_address(self.email,atr)
    end
    if(opts.admin_email_template)
      opts.admin_email_template.deliver_to_address(opts.admin_email,self.attributes)
    end
  end


  def handle_video_upload(args = {})
    self.upload_video
  end

  def destroy_video
    provider_connect
    begin
      @client.video_delete(self.provider_file_id)
    rescue Exception => e
      # Could not delete video
    end
  end

  def save_end_user
    EndUser.push_target(self.email,:name => self.name,:zip => self.zip) unless self.receive_updates.to_i != 1
  end


  def ensure_file
    if !self.file
      self.errors.add(:file_id,'is missing')
    elsif !%w(avi mov m4v).include?(self.file.extension.to_s.downcase)
      self.errors.add(:file_id,'is not a valid video file')
      self.file.destroy
      self.file_id = nil
    end
  end

end
