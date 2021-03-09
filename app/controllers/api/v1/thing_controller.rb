class Api::V1::ThingController < ApplicationController
    before_action :authenticate_user!
    def index
        things = PermissionsManager.get_things(current_user)
        render json: { 'things': things }, status: 200
    end

    def show
        thing_name = params[:id]
        com = IotCoreCom.new(current_user, thing_name)
        state = com.get_state
        thing = Thing.find_by aws_name: thing_name
        thing_hash = thing.as_json
        thing_hash[:state] = state
        render json: thing_hash, status: 200
    end

    def create
        # this create is only to be accessed by the production line script!
        begin
            name_len = rand(24) + 6  # 6 <= name_len < 24
            h = create_params
            h[:name] = SecureRandom.urlsafe_base64 name_len
            thing = PermissionsManager.create_thing(current_user, h)
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
        # com = IotCoreCom.new(current_user, thing_name)
        # result = com.set_state is_on
        mqtt_client = MqttBrokerWrapper.new(current_user, thing_name)
        result = mqtt_client.set_state(is_on)
        result_hash = result.as_json
        render json: result_hash, status: 200
    end

    def destroy
        # this create is only to be accessed by the production line script!
        begin
            PermissionsManager.delete_thing(current_user, params[:id])
        rescue Exceptions::NoPermissionError
            render json: {}, status: 403
            return
        end
        render json: { 'success': true }, status: 200
    end

    private

    def create_params
        params.permit(:password, :meta, :thing_type_id)
    end

    def activate_params
        params.permit(:name, :key, :cluster_group_id)
    end

end
