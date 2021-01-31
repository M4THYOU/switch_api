class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters, if: :devise_controller?
    respond_to :json

    def sign_up(resource_name, resource)
        ConfirmMailer.confirm_email resource.email
        # need to send an email.
        # sign_in(resource_name, resource)
    end

    protected

    def configure_permitted_parameters
        # Permit the `subscribe_newsletter` parameter along with the other
        # sign up parameters.
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    end
end
