require 'mqtt'

# Want an instance of this, ALWAYS active somewhere
class MqttBrokerWrapper
    def initialize(current_user, thing_name)
        PermissionsManager.has_thing_permission(current_user, thing_name)
        @thing_name = thing_name
    end

    def get_state
        client.subscribe(state_topic)
        payload = '{"state":{"error":"Timeout"}}'
        begin
            Timeout.timeout(10) do
                client.get(state_topic) do |topic, raw_payload|
                    puts topic
                    if topic == state_topic
                        payload = raw_payload
                        break
                    end
                end
            end
        rescue TimeoutError
            Rails.logger.error("Timeout getting state for: #{state_topic}")
        end
        client.unsubscribe(state_topic)
        state = JSON.parse(payload)
        state['state']
    end

    # is_on must be either 0 or 1.
    def set_state(is_on)
        state = { :on => is_on }
        payload = { :state => state }
        client.publish(state_topic, payload.to_json, true, 1)
        state
    end

    private

    def state_topic
        'thing/switch/' + @thing_name + '/state'
    end

    def client
        Rails.application.config.mqtt_service
    end

end
