class Api::V1::ThingController < ApplicationController
    # before_action :authenticate_user!
    def index
        Thing.all
    end

    def show
        thing_name = params[:id]
        com = IotCoreCom.new thing_name
        state = com.get_state
        thing = Thing.find_by aws_name: thing_name
        thing_hash = thing.as_json
        thing_hash[:state] = state
        render json: thing_hash, status: 200
    end

    # https://a2eis0wug3zm6u.iot.us-east-2.amazonaws.com/things/esp8266/shadow
    #
    # a2eis0wug3zm6u-ats.iot.us-east-2.amazonaws.com # use this one for device itself I think
    def update
        thing_name = params[:id]
        is_on = params[:on].to_i
        com = IotCoreCom.new thing_name
        result = com.set_state is_on
        puts result
        result_hash = result.as_json
        render json: result_hash, status: 200
    end

    private

    def update_params
    end

end
