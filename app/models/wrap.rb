class Wrap
  PHANTOM_FILE = "wrap.js"
  CHECK_DRIVE_URL_1 = "https://mail.google.com/e/get_video_info"
  CHECK_DRIVE_URL_2 = "https://drive.google.com/e/get_video_info"
  CHECK_DRIVE_URL_3 = "https://docs.google.com/e/get_video_info"
  # https://drive.google.com/file/d/FILE_ID/edit?usp=sharing
  # https://drive.google.com/file/d/0Bzvpzqrx7zGoZVJtcHZNdHM1SVE/edit?usp=sharing
  # https://docs.google.com/uc?id=0Bzvpzqrx7zGoZVJtcHZNdHM1SVE&export=download
  # curl -Ls -w %{url_effective} -o /dev/null https://docs.google.com/uc?export=download&confirm=Hl_n&id=0Bzvpzqrx7zGoZVJtcHZNdHM1SVE

  def self.crawl_by_dom(crawl_url = "https://drive.google.com/file/d/0Bzvpzqrx7zGoZVJtcHZNdHM1SVE/view")
    puts "Staring to crawl list anime from url #{crawl_url}"
    url_list = []
    if crawl_url.present?
      html_content = Phantomjs.run(PHANTOM_FILE, crawl_url)
      page = Nokogiri::HTML(html_content)

      script_contents = page.css("script")
      script_content = ""
      script_contents.each do |script|
        script_content = script if script.to_s.include? "fmt_stream_map"
      end
      fmt_list = script_content.to_s.match /(\[\"fmt_stream_map\".*.\"\])/

      fmt_1 = fmt_list[0]
      fmt_2 = fmt_1.split('"')
      fmt_value = ""
      fmt_2.each do |value|
        fmt_value = value if value.include? '|'
      end

      fmt_value.split(",").each do |value|
        url_list << value
      end

      puts fmt_list
      url_list
    end
  end

  def self.crawl_by_docid(options = {})
    docid = options[:docid] || "0Bzvpzqrx7zGoZVJtcHZNdHM1SVE"
    headers = options[:headers] || {}
    data = { status: false, data: ""}

    if docid.present?
      begin
        google_drive_video_url = "#{CHECK_DRIVE_URL_1}?docid=#{docid}"
        drive_content_obj = HTTParty.get(google_drive_video_url, headers: headers)
        ap drive_content_obj.headers
        drive_content = drive_content_obj.body
        # puts drive_content
        drive_params = Rack::Utils.parse_nested_query(drive_content).deep_symbolize_keys
        # puts drive_params
        urls = []
        drive_params[:fmt_stream_map].split(',').each do |link|
          url = URI.parse(CGI.unescape(link.split('|')[1]))

          params = CGI.parse(url.query || "")
          params.delete('driveid')
          url.query = URI.encode_www_form(params)

          url.host = "redirector.googlevideo.com"
          video_link = CGI.unescape(url.to_s)

          # call curl -i video_link before send it to users to ensure that users can play videos 99%

          urls << { itag: link.split('|')[0], url: video_link }
        end

        data[:status] = true
        data[:data] = urls
      rescue Exception => e
        puts "#{e.to_s}"
        data[:status] = false
      end
    end
    data
  end
end
