class VideoVideo < DomainModel
  belongs_to :end_user
  has_domain_file :file_id
  has_content_tags

  validates_presence_of :email

  before_create :generate_video_hash, :assign_name
  after_update :update_meta_data
  after_create :send_email

  named_scope :with_end_user, lambda { |user| {:conditions => {:end_user_id=>user.id} } }
  named_scope :approved , { :conditions => ['moderated > 0'] }

  content_node :push_value => true 

  attr_accessor :description_other

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
    scope = VideoVideo

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

  def self.category_options
    Video::AdminController.module_options.category_options
  end

  def self.top_tags
    VideoVideo.tag_cloud[0..5].map { |t| t[:name] }
  end

  def assign_name 
    self.name = self.file.name
  end

  def upload_video
    provider_connect         
    video = @client.video_upload(File.open(self.file.filename), :title => self.file.name, :category => 'People', :list => self.moderate_value)
    self.provider_file_id = video.unique_id
    self.provider = 'youtube'
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
      c.h_tag('video:name') { |tag| t.locals.video.name }
      c.datetime_tag('video:created_at') { |t| t.locals.video.created_at }
      c.h_tag('video:description',:format => 'simple') { |tag| t.locals.video.description }
      c.h_tag('video:user') { |tag| t.locals.video.end_user ? t.locals.video.end_user.name : ''} 
      c.define_tag('video:image') { |t| image_tag "http://img.youtube.com/vi/#{t.locals.video.provider_file_id}/0.jpg", t.attr  } 
      c.h_tag('video:name') { |t| h t.locals.video.name }
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
    @client.video_update(self.provider_file_id,:title => self.name, :description => self.description, :category => 'People', :keywords => self.tags_array, :list => self.moderate_value)
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
  end


  def handle_video_upload(args = {})
    self.upload_video
  end

end
