class Video::ManageController < ModuleController      

  component_info 'Video'     
  permit :video_manage

  cms_admin_paths "content",
    "Video" =>  {:action => 'index'}

  def index
    cms_page_path ["Content"], "Video"
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
