class Video::EditFeature < ParagraphFeature

  feature :video_page_list, :default_feature => <<-FEATURE
    <cms:video_table style='width:100%'>
      <cms:row>
        <td><cms:checkbox/></td>
        <td><cms:edit_link><cms:name/></cms:edit_link></td>
      </cms:row>
    </cms:video_table>
   FEATURE

  def video_page_list_feature(data)
    webiva_feature(:video_page_list) do |c|
      c.end_user_table_tag('video_table','video',:container_id => "cmspara_#{paragraph.id}", :no_pages => data[:mini] ? true : nil,
                           :actions => data[:mini] ? nil : [['Delete','delete','Delete the selected videos?']]) { |t| data[:tbl] }
      c.link_tag('video_table:row:edit') { |t| "#{data[:options].edit_page_url}/#{t.locals.video.id}" }
      c.value_tag('video_table:row:name') { |t| h t.locals.video.name }
    end

  end

  feature :video_page_edit, :default_feature =>  <<-FEATURE
      <cms:form>
        <cms:errors>
          <div class='error'>
            There was a problem saving your video:<br/>
          <cms:value/>
          </div>
        </cms:errors>
        <div class='label'>Name:</div>
        <cms:name/><br/>
        <div class='label'>Description:</div>
        <cms:description/><br/>
        <div class='label'>Keywords:</div>
        <cms:tag_names/><br/>
        <cms:save/>
      </cms:form>
  FEATURE


  def video_page_edit_feature(data)
    webiva_feature(:video_page_edit) do |c|
      c.form_for_tag('form','video') { |t| data[:video] }
      c.form_error_tag('form:errors')
      c.field_tag('form:name')
      c.field_tag('form:description')
      c.field_tag('form:tag_names',:size => 50)
      c.submit_tag('form:save')        
    end
  end

end
