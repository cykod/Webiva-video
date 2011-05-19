class Video::EditController < ParagraphController

  editor_header 'Video Paragraphs'
  
  editor_for :list, :name => "Editor List", :feature => :video_page_list
  editor_for :edit, :name => "Edit", :feature => :video_page_edit, :inputs => [[ :video_id, "Video Id", :path ]] 

  class ListOptions < HashModel
    # Paragraph Options
    attributes :edit_page_id => nil

    page_options :edit_page_id

    options_form(
                  fld(:edit_page_id, :page_selector) # <attribute>, <form element>, <options>
                 )
  end

  class EditOptions < HashModel
    # Paragraph Options
    attributes :list_page_id => nil

    page_options :list_page_id

    options_form(
                  fld(:list_page_id, :page_selector) # <attribute>, <form element>, <options>
                 )
  end

end
