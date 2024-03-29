class SessionsController < Devise::SessionsController
    respond_to :json

    def create
        self.resource = warden.authenticate!(auth_options)
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource)
    end

    private

    def respond_with(resource, _opts = {})
        render json: resource
    end
    def respond_to_on_destroy
        head :ok
    end
end
