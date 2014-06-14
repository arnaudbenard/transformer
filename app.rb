require 'sinatra'
require 'httparty'
require 'crack'

get '/status' do
    content_type :json

    response = []
    responseTFL = HTTParty.get('http://cloud.tfl.gov.uk/TrackerNet/LineStatus')

    Crack::XML.parse(responseTFL.body)["ArrayOfLineStatus"]["LineStatus"].each do |branch|

        disruption = {}

        if !branch["BranchDisruptions"].nil?
            d = branch["BranchDisruptions"]["BranchDisruption"]
            disruption["station_to"] = d["StationTo"]["Name"]
            disruption["station_from"] = d["StationFrom"]["Name"]
            disruption["station_via"] = d["StationVia"]["Name"] if !d["StationVia"].nil?
        end

        response << {
            :name => branch['Line']['Name'],
            :status => branch['Status']['Description'],
            :disruption => disruption
        }
    end

    {"statuses" => response}.to_json
end
