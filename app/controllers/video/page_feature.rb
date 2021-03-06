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
      c.link_tag('video:detail') { |t| data[:options].detail_page_node.link(t.locals.video.id.to_s) if data[:options].detail_page_node } 
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
      c.h_tag('video:name') { |t| t.locals.video.name }
      c.datetime_tag('video:created_at') { |t| t.locals.video.created_at }
      c.h_tag('video:description',:format => 'simple') { |t| t.locals.video.description }
      c.h_tag('video:user') { |t| t.locals.video.end_user ? t.locals.video.end_user.name : ''} 
      c.define_tag('video:image') { |t| image_tag "http://img.youtube.com/vi/#{t.locals.video.provider_file_id}/0.jpg", t.attr  } 
      c.h_tag('video:name') { |t| h t.locals.video.name }
      c.h_tag('video:state') { |t| h t.locals.video.state}
      c.h_tag('video:recipient') { |t| h t.locals.video.recipient}
      c.define_tag('video:player') { |t| 
         width = t.attr['width'] || 425
         height = t.attr['height'] || 350
         "<iframe width='#{width}' height='#{height}' src='http://www.youtube.com/embed/#{t.locals.video.provider_file_id}?rel=0&wmode=transparent' frameborder='0' allowfullscreen></iframe>"
      }

  end

 feature :video_page_search, :default_feature =>  <<-FEATURE
 <cms:search>
    <cms:query/> 
    <cms:category/>
    <cms:tags/>
    <cms:submit/>
 </cms:search>
 <cms:searching>
    <cms:videos>
      <ul>
      <cms:video>
        <li><cms:detail_link><cms:image height='120'/> <cms:name/></cms:detail_link></li>
      </cms:video>
      </ul>
    </cms:videos>
    <cms:no_videos>
    No Matching Videos
    </cms:no_videos>
  </cms:searching>


 FEATURE


  def video_page_search_feature(data)
    webiva_feature(:video_page_search) do |c|
      c.form_for_tag('search','q', :html => { :method => 'get' }) { |t| data[:search] }
      c.field_tag('search:query') 
      c.field_tag('search:state', :control => 'select')  { |t| [['State', nil]] + Content::CoreField::UsStateField.states_select_options }
      c.field_tag('search:category', :control => 'select')  { |t| [['--Select Category--',nil]] + VideoVideo.category_options }
      c.field_tag('search:tags',:control => 'check_boxes') { |t| VideoVideo.top_tags }
      c.submit_tag('search:submit') 

      c.expansion_tag('searching') { |t| data[:searching] }

   c.loop_tag('video') { |t| data[:videos] }
      define_video_detail_tags(c)
      c.link_tag('video:detail') { |t| data[:options].detail_page_node.link(t.locals.video.id.to_s) if data[:options].detail_page_node } 
      c.pagelist_tag('videos:pages') { |t| data[:pages] }
    end
  end

 feature :video_page_upload, :default_feature =>  <<-FEATURE
 <cms:upload>
 <cms:errors/>
    <cms:name/>
    <cms:email/> <cms:zip placeholder='Zip'/>
    <cms:recipient/> <cms:state placeholder='State'/>
    <cms:file_id/>
    <label><cms:terms/> I agree to the Terms and conditions of this site</label>
    <label><cms:receive_updates/> I would like to receive email updates from  "Friend a Nurse"</label>
    <cms:submit/>
  </cms:upload>
  <cms:uploaded>
  Thank you! Your video has been uploaded.

  </cms:uploaded>

 FEATURE


  def video_page_upload_feature(data)
    webiva_feature(:video_page_upload) do |c|
      c.form_for_tag('upload','video', :html => { :method => 'post', :enctype => 'multipart/form-data' }) { |t| data[:uploaded] ? nil : data[:video] }
      c.form_error_tag('upload:errors')
      c.field_tag('upload:name') 
      c.field_tag('upload:recipient') 
      c.field_tag('upload:state', :control => 'select')  { |t| [['State', nil]] + Content::CoreField::UsStateField.states_select_options }
      c.field_tag('upload:email')
      c.field_tag('upload:zip')
      c.field_tag('upload:file_id',:control => 'upload_document')
      c.field_tag('upload:terms', :control => 'check_box')
      c.field_tag('upload:receive_updates', :control => 'check_box')

      c.submit_tag('upload:submit') 
      c.expansion_tag('uploaded') { |t| data[:uploaded] }
    end
  end



  

end
