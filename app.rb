# wav 2 mp3 convert service
# https://github.com/nemilya/wav2mp3
#
# MIT License
#

require 'rubygems'
require 'sinatra'
require 'yaml'
require 'json'

config_path = File.join("config", "conf.yml")

configure :development do
  config_path = File.join("config", "conf.local.yml")
end

$service_settings = nil
if File.exists?(config_path)
  $service_settings = YAML.load(File.read(config_path))
end

helpers do
  def is_api_key_valid?(api_key)
    $service_settings["wav2mp3"] && api_key == $service_settings["wav2mp3"]["api_key"].to_s
  end

   def random_string(length=5)
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
    r = ''
    length.times { r << chars[rand(chars.size)] }
    r
  end

  def get_result_file_name
    random = random_string
    file_name = Time.now.strftime("%Y%m%d-%H%M%S-") + random + '.mp3'
  end

  def convert(file_in, file_out)
    cmd_path = $service_settings["wav2mp3"]["lame_path"]
    cmd = "#{cmd_path} #{file_in} #{file_out}"
    `#{cmd}`
  end
end

get '/convert/:api_key' do
  if is_api_key_valid?(params[:api_key])
    @api_key = params[:api_key]
    erb :convert
  else
    halt 410
  end
end

post '/convert' do
  unless is_api_key_valid?(params[:api_key])
    halt 410
  end
  ret = {}

  tmp_file_path = params['file'][:tempfile].path

  out_file_name = get_result_file_name
  out_file_path_web = File.join("out", out_file_name)
  out_file_path_local = File.join("public", out_file_path_web)
  if convert(tmp_file_path, out_file_path_local)
    ret[:result] = 'ok'
    # absolute, without HOST
    ret[:result_file_path] = '/' + out_file_path_web
  else
    ret[:result] = 'error'
  end
  ret.to_json
end