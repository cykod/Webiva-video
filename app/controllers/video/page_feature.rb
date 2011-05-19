class Video::PageFeature < ParagraphFeature

  feature :video_page_user_list, :default_feature => <<-FEATURE
    <cms:video_table style='width:100%'>
      <cms:row>
        <td><cms:edit_link><cms:name/></cms:edit_link></td>
      </cms:row>
    </cms:video_table>
   FEATURE

  def video_page_user_list_feature(data)
    webiva_feature(:video_page_user_list) do |c|
      c.end_user_table_tag('video_table','video',:container_id => "cmspara_#{paragraph.id}", :no_pages => data[:mini] ? true : nil) { |t| data[:tbl] }
      c.link_tag('video_table:row:edit') { |t| "#{data[:options].user_view_page_url}/#{t.locals.video.id}" }
      c.value_tag('video_table:row:name') { |t| h t.locals.video.name }
    end

  end

  
  feature :video_page_user_view, :default_feature =>  <<-FEATURE
    <div class='video'>
      <h1><cms:name/></h1>
    </div>
    <div class='video_details'>
      Created <cms:created_at /> by <cms:user/> <br/>
      Description <cms:description /><br/>
    </div>
    <div style='clear:both;'></div>
  FEATURE
  
  def video_page_user_view_feature(data)
    webiva_feature(:video_page_user_view) do |c|
      c.link_tag('user_list_page') { |tag| data[:video] }
      c.value_tag('name') { |tag| data[:video].name }
      c.value_tag('created_at') { |tag| data[:video].created_at }
      c.value_tag('user') { |tag| data[:video].end_user.name }
      c.value_tag('description') { |tag| data[:video].description }
    end  
  end   
  

end
