require 'client_convert.rb' 

# config
api_key = '123123'
service_url = 'http://localhost:4567'

options = {}
options[:api_key] = api_key
options[:service_url] = service_url

file_source = 'test.wav'

cc = ClientConverter.new options
if cc.convert(file_source)
  File.open(file_source+'.result.mp3', "wb") do |f|
    f << cc.result
  end
else
  p 'error:'
  p cc.error
end