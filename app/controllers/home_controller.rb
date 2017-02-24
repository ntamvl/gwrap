class HomeController < ApplicationController
  def index
    functions = []
    functions << { name: 'get_video_info', params: ["link"], path: get_video_info_path }
    data = {
      functions: functions
    }
    render json: data
  end

  def get_video_info
    puts "--------------"
    puts request.remote_ip
    puts request.user_agent
    puts "--------------"
    headers = {
      "user-agent": request.user_agent,
      "remote-addr": request.remote_ip,
      "timeout": 3000,
      "retries": 1,
    }
    docid = params[:docid]
    data = { docid: docid }
    data[:data] = Wrap.crawl_by_docid(docid: docid, headers: headers) if docid.present?
    render json: data
  end
end
