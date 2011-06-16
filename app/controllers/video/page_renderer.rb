class Video::PageRenderer < ParagraphRenderer

  features '/video/page_feature'

  paragraph :user_list
  paragraph :user_view
  paragraph :search

  def user_list
    @options = paragraph_options :user_list

    scope = VideoVideo
    @pages, @videos = VideoVideo.paginate(params[:page],
                                          :order => 'featured DESC,created_at DESC', :per_page => @options.per_page)

    render_paragraph :feature => :video_page_user_list
  end

  def user_view
    @options = paragraph_options :user_view
  
    if editor?
      @video = VideoVideo.find(:first)
    else
      conn_type,conn_id = page_connection
      @video = VideoVideo.find(conn_id)
    end

    render_paragraph :feature => :video_page_user_view

  end


  class VideoSearch < HashModel
    attributes :query => nil, :category => nil, :tags => nil


  end

  def search

    @search = new VideoSearch(params[:search])

    if params[:search] 
      @pages, @results = @
     @vVideoVideo.search(@search.to_hash)
  end

end
