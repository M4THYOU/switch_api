module Broker
    class Wrapper
    # @param current_user [User]
    # @param thing_name [String] the name of the 'thing' being operated on.
    # @param is_aws [Boolean] whether or not this connection is using IoT Core.
    def initialize(current_user, thing_name, is_aws=true)
        if is_aws
             @client = IotCoreCom.new(current_user, thing_name)
        else
            @client = MqttBrokerWrapper.new(current_user, thing_name)
        end
    end

    # get_state returns the state of the current thing.
    # @return [String] a json string containing the current state.
    def get_state
        @client.get_state
    end

    # set_state(is_on) sets the state of the current thing, to on or off.
    # @param is_on [Number] ON=1 or OFF=0, which will you set it??
    def set_state(is_on)
        @client.set_state(is_on)
    end

    end
end
