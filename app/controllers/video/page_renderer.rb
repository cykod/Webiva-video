class Video::PageRenderer < ParagraphRenderer

  features '/video/page_feature'

  paragraph :user_list
  paragraph :user_view
  paragraph :search
  paragraph :upload

  def user_list
    @options = paragraph_options :user_list

    scope = VideoVideo
    @pages, @videos = VideoVideo.approved.paginate(params[:page],
                                          :order => 'featured DESC,created_at DESC', :per_page => @options.per_page)

    render_paragraph :feature => :video_page_user_list
  end

  def user_view
    @options = paragraph_options :user_view
  
    if editor?
      @video = VideoVideo.find(:first)
    else
      conn_type,conn_id = page_connection
      @video = VideoVideo.approved.find(conn_id)
    end
    set_title(@video.name) if @video

    render_paragraph :feature => :video_page_user_view

  end


  class VideoSearch < HashModel
    attributes :query => nil, :category => nil, :tags => nil


  end

  def search
    @options = paragraph_options :search

    @search = VideoSearch.new(params[:q])

    if params[:q] 
      @searching = true
      @pages, @videos =VideoVideo.search(params[:page],@search.to_hash)
    end

    render_paragraph :feature => :video_page_search

  end

  def upload
    @video = VideoVideo.new(:receive_updates => true, :manual => true)
    handle_file_upload(params[:video],:file_id) if params[:video]
    if request.post? && params[:video] && @video.update_attributes(params[:video].slice(:name,:email,:terms,:receive_updates,:zip,:file_id,:recipient,:state))
      @video.run_worker(:handle_video_upload)
      @uploaded = true
    end

    render_paragraph :feature => :video_page_upload
  end

end
