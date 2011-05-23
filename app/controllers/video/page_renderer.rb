class Video::PageRenderer < ParagraphRenderer

  features '/video/page_feature'

  paragraph :user_list
  paragraph :user_view

  def user_list
    @options = paragraph_options :user_list

    @tbl = end_user_table( :video_table,
                          VideoVideo,
                          [ 
                            EndUserTable.column(:blank),
                            EndUserTable.column(:string,'videos.name',:label => 'Video Name'),
                            EndUserTable.column(:string,'videos.featured',:label => 'Featured')
                          ]
                         )
                             
    end_user_table_generate @tbl

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

end
