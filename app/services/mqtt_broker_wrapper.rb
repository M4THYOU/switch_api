require 'mqtt'

# Want an instance of this, ALWAYS active somewhere
class MqttBrokerWrapper
    def test
        puts mqtt_service
    end

    def turn_on(name)
        # mqtt_service.publish(name + '/state', '{"state":{"on":0}}', true, 1)
    end

    def mqtt_service
        Rails.application.config.mqtt_service
    end

end
