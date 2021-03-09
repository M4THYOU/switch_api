require 'mqtt'

# Want an instance of this, ALWAYS active somewhere
class MqttBrokerWrapper
    def initialize(current_user, thing_name)
        PermissionsManager.has_thing_permission(current_user, thing_name)
        @thing_name = thing_name
    end

    def get_state
        # TODO
    end

    # is_on must be either 0 or 1.
    def set_state(is_on)
        state = { :on => is_on }
        payload = { :state => state }
        client.publish(@thing_name + '/state', payload.to_json, true, 1)
        state
    end

    private

    def client
        Rails.application.config.mqtt_service
    end

end
