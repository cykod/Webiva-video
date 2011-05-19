class Video::PageController < ParagraphController

  editor_header 'Video Paragraphs'
  
  editor_for :user_list, :name => "User List", :feature => :video_page_user_list
  editor_for :user_view, :name => "User View", :feature => :video_page_user_view, :inputs => [[ :video_id, "Video Id", :path ]] 

  class UserListOptions < HashModel
    # Paragraph Options
    attributes :user_view_page_id => nil

    page_options :user_view_page_id

    options_form(
                  fld(:user_view_page_id, :page_selector) # <attribute>, <form element>, <options>
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

end
