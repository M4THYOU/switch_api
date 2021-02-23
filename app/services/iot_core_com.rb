class IotCoreCom

    def initialize(current_user, thing_name)
        PermissionsManager.has_thing_permission(current_user, thing_name)
        @thing_name = thing_name
        @signer = Aws::Sigv4::Signer.new(
            service: 'iotdata',
            region: 'us-east-2',
            access_key_id: ENV['AWS_ACCESS_KEY_ID'],
            secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        )
        host = 'https://a2eis0wug3zm6u.iot.us-east-2.amazonaws.com'
        @base_uri = host + '/things/' + thing_name + '/shadow'
    end

    def get_state
        signature = @signer.sign_request(
            http_method: 'GET',
            url: @base_uri,
            body: {}.to_json
        )
        uri = URI(@base_uri)
        result = ''
        Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
            request = Net::HTTP::Get.new uri
            request.body = {}.to_json
            request = set_headers(request, signature)
            response = http.request request
            result = response.body
        end
        if result.blank?
            {:error => 'no response found.'}
        else
            state = JSON.parse result
            state["state"]["delta"]
        end
    end

    def set_state(is_on)
        document = { :state => { :desired => { :on => is_on } } }
        signature = @signer.sign_request(
            http_method: 'POST',
            url: @base_uri,
            body: document.to_json
        )
        uri = URI(@base_uri)
        result = ''
        Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
            request = Net::HTTP::Post.new uri
            request.body = document.to_json
            request = set_headers(request, signature)
            response = http.request request
            result = response.body
        end
        if result.blank?
            {:error => 'no response found.'}
        else
            state = JSON.parse result
            state["state"]["desired"]
        end
    end

    private

    def set_headers(request, signature)
        request['Host'] = signature.headers['host']
        request['X-Amz-Date'] = signature.headers['x-amz-date']
        request['X-Amz-Security-Token'] = signature.headers['x-amz-security-token']
        request['X-Amz-Content-Sha256']= signature.headers['x-amz-content-sha256']
        request['Authorization'] = signature.headers['authorization']
        request['Content-Type'] = 'application/json'
        request
    end

end