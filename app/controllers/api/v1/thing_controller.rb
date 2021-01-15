class Api::V1::ThingController < ApplicationController
  def index
  end

  def show
  end

  # https://a2eis0wug3zm6u.iot.us-east-2.amazonaws.com/things/esp8266/shadow
  #
  # a2eis0wug3zm6u-ats.iot.us-east-2.amazonaws.com # use this one for device itself I think
  def update
    things = Thing.all
    puts "fuck"

    signer = Aws::Sigv4::Signer.new(
      service: 'iotdata',
      region: 'us-east-2',
      # static credentials
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    host = 'https://a2eis0wug3zm6u.iot.us-east-2.amazonaws.com'
    thing_name = 'esp8266'
    uri_string = host + '/things/' + thing_name + '/shadow'

    signature = signer.sign_request(
      http_method: 'GET',
      url: uri_string,
      body: {}.to_json
    )
    uri = URI(uri_string)

    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      request = Net::HTTP::Get.new uri
      request.body = {}.to_json

      request['Host'] = signature.headers['host']
      request['X-Amz-Date'] = signature.headers['x-amz-date']
      request['X-Amz-Security-Token'] = signature.headers['x-amz-security-token']
      request['X-Amz-Content-Sha256']= signature.headers['x-amz-content-sha256']
      request['Authorization'] = signature.headers['authorization']
      request['Content-Type'] = 'application/json'
      response = http.request request
      puts response.body
    end

    render json: things, status: 200
  end

  private

  def update_params
  end

end
