class Video::PageFeature < ParagraphFeature

  feature :video_page_user_list, :default_feature => <<-FEATURE
    <cms:videos>
      <cms:video>
        <cms:image/> <cms:detail_link><cms:name/></cms:detail_link>
        <cms:player/>
      </cms:video>
    </cms:videos>
   FEATURE

  def video_page_user_list_feature(data)
    webiva_feature(:video_page_user_list,data) do |c|
      c.loop_tag('video') { |t| data[:videos] }
      define_video_detail_tags(c)
      c.link_tag('video:detail') { |t| data[:options].detail_page_node.link(t.locals.video_id) if data[:options].detail_page_node } 
      c.pagelist_tag('videos:pages') { |t| data[:pages] }
    end

  end

  
  feature :video_page_user_view, :default_feature =>  <<-FEATURE
  <cms:video>
    <div class='video'>
      <h1><cms:name/></h1>
    </div>
    <div class='video_details'>
      Created <cms:created_at /> by <cms:user/> <br/>
      Description <cms:description /><br/>
    </div>
    <div class='video_frame'>
       <cms:player/>
    </div>
  </cms:video>
    <div style='clear:both;'></div>
  FEATURE
  
  def video_page_user_view_feature(data)
    webiva_feature(:video_page_user_view) do |c|
      c.expansion_tag('video') { |t| t.locals.video = data[:video] }
      define_video_detail_tags(c)
    end  
  end   


  def define_video_detail_tags(c) 
      c.h_tag('video:name') { |tag| t.locals.video.name }
      c.datetime_tag('video:created_at') { |tag| t.locals.video.created_at }
      c.h_tag('video:description',:format => 'simple') { |tag| t.locals.video.description }
      c.h_tag('video:user') { |tag| t.locals.video.end_user ? t.locals.video.end_user.name : ''} 
      c.define_tag('video:image') { |t| image_tag "http://img.youtube.com/vi/#{t.locals.video.provider_file_id}/0.jpg", t.attr  } 
      c.h_tag('video:name') { |t| h t.locals.video.name }
      c.define_tag('video:player') { |t| 
         width = t.attr['width'] || 425
         height = t.attr['height'] || 350
         "<iframe width='#{width}' height='#{height}' src='http://www.youtube.com/embed/#{t.locals.video.provider_file_id}?rel=0' frameborder='0' allowfullscreen></iframe>"
      }

  end
  

end
