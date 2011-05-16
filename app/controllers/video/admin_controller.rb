
class Video::AdminController < ModuleController

  component_info 'Video', :description => 'Video support', 
                              :access => :public
                              
  # Register a handler feature
  register_permission_category :video, "Video" ,"Permissions related to Video"
  
  register_permissions :video, [ [ :manage, 'Manage Video', 'Manage Video' ],
                                  [ :config, 'Configure Video', 'Configure Video' ]
                                  ]
  cms_admin_paths "options",
     "Video Options" => { :action => 'index' },
     "Options" => { :controller => '/options' },
     "Modules" => { :controller => '/modules' }

  permit 'video_config'

  content_model :videos

  def self.get_videos_info
    [ { :name => 'Video management', 
      :permission => :video_manage,
      :url => { :controller => 'video/manage' } 
    } ]
  end

  public 
 
  def options
    cms_page_path ['Options','Modules'],"Video Options"
    
    @options = self.class.module_options(params[:options])
    
    if request.post? && @options.valid?
      Configuration.set_config_model(@options)
      flash[:notice] = "Updated Video module options".t 
      redirect_to :controller => '/modules'
      return
    end    
  
  end
  
  def self.module_options(vals=nil)
    Configuration.get_config_model(Options,vals)
  end
  
  class Options < HashModel
    attributes :provider => 'Select video service provider'
    attributes :developer_key => 'Enter developer key'
    attributes :user_name => 'Enter user name'
    attributes :password => 'Password'
    attributes :email_template_id => 'Select email template'
    validates_presence_of :developer_key
    validates_presence_of :user_name
    validates_presence_of :password
    validates_presence_of :provider
    validates_presence_of :email_template_id
  end

end
