require "rest-client"
require "json"

class ClientConverter
  def initialize(options={})
    @error = nil
    @result = nil
    @service_url = options[:service_url]
    @api_key = options[:api_key]
  end

  def convert(file_source)
    upload_url = @service_url + '/convert'

    # remote convert
    # POST
    res = RestClient.post(upload_url, 
      :file => File.new(file_source, "rb"), 
      :api_key=>@api_key) rescue nil

    if res.nil?
      @error = 'Upload error'
      return false
    end

    ret = JSON.parse(res) rescue nil

    if ret && ret["result"] == 'ok'
      # download file
      result_file_path = ret["result_file_path"]
      result_file_url = @service_url + result_file_path
      @result = RestClient.get result_file_url
      return true
    else
      @error = 'Convert error'
      return false
    end
  end

  def result
    @result
  end

  def error
    @error
  end
end