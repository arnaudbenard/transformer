require 'sinatra'
require 'httparty'
require 'crack'

get '/' do
    response = HTTParty.get('http://cloud.tfl.gov.uk/TrackerNet/LineStatus')
    Crack::XML.parse(response.body).to_json
end
