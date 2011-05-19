class Video::PageRenderer < ParagraphRenderer

  features '/video/page_feature'

  paragraph :list
  paragraph :edit

  def list
    @options = paragraph_options :list

    @tbl = end_user_table( :video_list,
                          VideoVideo,
                          [ 
                            EndUserTable.column(:blank),
                            EndUserTable.column(:string,'videos.name',:label => 'Video Name')
                          ]
                         )
                             
    end_user_table_generate @tbl

    render_paragraph :feature => :video_page_list
  end

  def edit
    @options = paragraph_options :edit
  
    if editor?
      @video = VideoVideo.find(:first)
    else
      conn_type,conn_id = page_connection
      @video = VideoVideo.find(conn_id)
    end

    if @video.end_user_id.blank?
      if @video.video_hash == params[:video_hash]
          @video.update_attribute(:end_user_id,myself.id)
      end
    end

    if @video.end_user !=  myself
      return render_paragraph :text => ''
    end

    if params[:video]
      if @video.update_attributes(params[:video])
        #redirect to index        
        redirect_paragraph @options.list_page_url and return
      end
    end

    render_paragraph :feature => :video_page_edit

  end

end
