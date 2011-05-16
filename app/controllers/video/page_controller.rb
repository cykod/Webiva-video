class Video::PageController < ParagraphController

  editor_header 'Video Paragraphs'
  
  editor_for :list, :name => "List", :feature => :video_page_list
  editor_for :view, :name => "View", :feature => :video_page_view
  editor_for :edit, :name => "Edit", :feature => :video_page_edit

  class ListOptions < HashModel
    # Paragraph Options
    # attributes :success_page_id => nil

    options_form(
                 # fld(:success_page_id, :page_selector) # <attribute>, <form element>, <options>
                 )
  end

  class ViewOptions < HashModel
    # Paragraph Options
    # attributes :success_page_id => nil

    options_form(
                 # fld(:success_page_id, :page_selector) # <attribute>, <form element>, <options>
                 )
  end

  class EditOptions < HashModel
    # Paragraph Options
    # attributes :success_page_id => nil

    options_form(
                 # fld(:success_page_id, :page_selector) # <attribute>, <form element>, <options>
                 )
  end

end
