class Api::V1::ThingController < ApplicationController
    before_action :authenticate_user!
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

    def create
        # this create is only to be accessed by the production line script!
        begin
            thing = PermissionsManager.create_thing(current_user, create_params)
        rescue Exceptions::NoPermissionError
            render json: {}, status: 403
            return
        end
        render json: { 'thing': thing }, status: 200
    end

    # used to activate a cluster!
    def activate
        begin
            thing = PermissionsManager.activate_thing(current_user, activate_params)
        rescue Exceptions::NoPermissionError
            render json: {}, status: 403
            return
        rescue Exceptions::AlreadyActivatedError
            render json: {}, status: 400
            return
        rescue Exceptions::NoAuth
            render json: {}, status: 401
            return
        end
        render json: { 'thing': thing }, status: 200
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

    def create_params
        params.permit(:name, :password, :meta, :thing_type_id)
    end

    def activate_params
        params.permit(:name, :key, :cluster_group_id)
    end

end
