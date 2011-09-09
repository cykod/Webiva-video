class Video::PageController < ParagraphController

  editor_header 'Video Paragraphs'
  
  editor_for :user_list, :name => "List Videos", :feature => :video_page_user_list
  editor_for :user_view, :name => "Display Video", :feature => :video_page_user_view, :inputs => [[ :video_id, "Video Id", :path ]] 
  editor_for :search, :name => "Search Videos", :feature => :video_page_search
  editor_for :upload, :name => "Upload Video", :feature => :video_page_upload, :no_options => true

  class UserListOptions < HashModel
    # Paragraph Options
    attributes :detail_page_id => nil,:per_page => nil

    page_options :detail_page_id 
    integer_options :per_page

    options_form(
                  fld(:detail_page_id, :page_selector),
                  fld(:per_page,:text_field) # <attribute>, <form element>, <options>
                 )
  end

  class UserViewOptions < HashModel
    # Paragraph Options
    attributes :user_list_page_id => nil

    page_options :user_list_page_id

    options_form(
                  fld(:user_list_page_id, :page_selector) # <attribute>, <form element>, <options>
                 )
  end


  class SearchOptions < HashModel
  # Paragraph Options
    attributes :detail_page_id => nil,:per_page => nil

    page_options :detail_page_id 
    integer_options :per_page

    options_form(
                  fld(:detail_page_id, :page_selector),
                  fld(:per_page,:text_field) # <attribute>, <form element>, <options>
                 )
  end


end
