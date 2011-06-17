class Video::ManageController < ModuleController      

  component_info 'Video'     
  permit :video_manage

  cms_admin_paths "content",
    "Video" =>  {:action => 'index'}

  active_table :video_table, VideoVideo, 
     [:check, :name, :featured, :description, :email, :created_at]

  def display_video_table(display=true)

    active_table_action('video') do |act,vids|
      case act
      when 'approve': VideoVideo.find(vids).map(&:approve)
      when 'feature': VideoVideo.find(vids).map(&:feature)
      when 'delete': VideoVideo.find(vids).map(&:destroy)
      end
    end
    

    @tbl = video_table_generate(params,:order => 'created_at DESC')
    render :partial => 'video_table' if display
  end

  def index
    cms_page_path ["Content"], "Video"
    display_video_table(false)
  end
  
  def edit
    @video = VideoVideo.find_by_id(params[:path][0]) || VideoVideo.new
    cms_page_path ["Content","Video"], 
      @video.new_record? ? "New video" : ["Edit %s",nil,@video.name]

    if request.post? && params[:video]
      if !params[:commit] 
        redirect_to :action => 'index'
      elsif @video.update_attributes(params[:video])
        flash[:notice] = 'Saved video`'
        redirect_to :action => 'index'
      end
    end

  end
end
