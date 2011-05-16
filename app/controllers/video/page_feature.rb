class Video::PageFeature < ParagraphFeature

  feature :video_page_list, :default_feature => <<-FEATURE
    List Feature Code...
  FEATURE

  def video_page_list_feature(data)
    webiva_feature(:video_page_list,data) do |c|
      # c.define_tag ...
    end
  end

  feature :video_page_view, :default_feature => <<-FEATURE
    View Feature Code...
  FEATURE

  def video_page_view_feature(data)
    webiva_feature(:video_page_view,data) do |c|
      # c.define_tag ...
    end
  end

  feature :video_page_edit, :default_feature => <<-FEATURE
    Edit Feature Code...
  FEATURE

  def video_page_edit_feature(data)
    webiva_feature(:video_page_edit,data) do |c|
      # c.define_tag ...
    end
  end

end
