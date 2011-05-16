class Video::PageRenderer < ParagraphRenderer

  features '/video/page_feature'

  paragraph :list
  paragraph :view
  paragraph :edit

  def list
    @options = paragraph_options :list

    # Any instance variables will be sent in the data hash to the 
    # video_page_list_feature automatically
  
    render_paragraph :feature => :video_page_list
  end

  def view
    @options = paragraph_options :view

    # Any instance variables will be sent in the data hash to the 
    # video_page_view_feature automatically
  
    render_paragraph :feature => :video_page_view
  end

  def edit
    @options = paragraph_options :edit

    # Any instance variables will be sent in the data hash to the 
    # video_page_edit_feature automatically
  
    render_paragraph :feature => :video_page_edit
  end

end
