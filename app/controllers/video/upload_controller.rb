

class Video::UploadController < ApplicationController
  skip_before_filter :verify_authenticity_token


  def index
    handle_file_upload(params,:media)

    video = VideoVideo.create(:email => params[:email],
                              :file_id => params[:media])

    video.run_worker(:handle_video_upload)

    render :json => { :status => 'ok' }
  end

end
