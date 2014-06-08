require 'sinatra'
require 'httparty'
require 'crack'

get '/status' do
    content_type :json

    response = []

    responseTFL = HTTParty.get('http://cloud.tfl.gov.uk/TrackerNet/LineStatus')

    Crack::XML.parse(responseTFL.body)["ArrayOfLineStatus"]["LineStatus"].each do |branch|
        response << branch['Line']['Name']
    end

    {"result" => response}.to_json
end
