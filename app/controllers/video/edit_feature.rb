class Video::EditFeature < ParagraphFeature

  feature :video_edit_list, :default_feature => <<-FEATURE
    <cms:video_table style='width:100%'>
      <cms:row>
        <td><cms:checkbox/></td>
        <td><cms:edit_link><cms:name/></cms:edit_link></td>
      </cms:row>
    </cms:video_table>
   FEATURE

  def video_edit_list_feature(data)
    webiva_feature(:video_edit_list) do |c|
      c.end_user_table_tag('video_table','video',:container_id => "cmspara_#{paragraph.id}", :no_pages => data[:mini] ? true : nil,
                           :actions => data[:mini] ? nil : [['Delete','delete','Delete the selected videos?']]) { |t| data[:tbl] }
      c.link_tag('video_table:row:edit') { |t| "#{data[:options].edit_page_url}/#{t.locals.video.id}" }
      c.value_tag('video_table:row:name') { |t| h t.locals.video.name }
    end

  end

  feature :video_edit_edit, :default_feature =>  <<-FEATURE
      <cms:form>
        <cms:errors>
          <div class='error'>
            There was a problem saving your video:<br/>
          <cms:value/>
          </div>
        </cms:errors>
        <ol>
         <li><cms:name_label/><cms:name/></li>
         <li><cms:category_label/><cms:category/></li>
         <li>Description:<cms:description_option/>
             <cms:description_other/>
         </li>
         <li>Keywords:<cms:tag_names/></li>
        </ol>
        <cms:save/>
      </cms:form>
  FEATURE


  def video_edit_edit_feature(data)
    webiva_feature(:video_edit_edit) do |c|
      c.form_for_tag('form','video') { |t| data[:video] }
      c.form_error_tag('form:errors')
      c.field_tag('form:name')
      c.field_tag('form:category', :control => :radio_buttons, :separator => "<br/>")   { |t| Video::AdminController.module_options.category_options }
      c.field_tag('form:description_option', :control => :radio_buttons, :separator => "<br/>" ) { |t|  Video::AdminController.module_options.descriptions_options + [['Other','other']] }

      c.field_tag('form:description_other', :onfocus => "document.getElementById('video_description_option_other').checked = true")
      c.field_tag('form:tag_names',:size => 50)
      c.submit_tag('form:save')        
    end
  end

end
