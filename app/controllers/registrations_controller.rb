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

    def build_resource(hash = {})
        email = hash[:email]
        u = User.find_by(email: email)
        if u.nil?
            self.resource = User.new_with_session(hash, session)
        elsif u.first_name.blank? and u.last_name.blank? and u.confirmation_token.blank? and u.confirmed_at.blank?
            hash[:invitation_token] = nil
            hash[:invitation_created_at] = nil
            hash[:invitation_sent_at] = nil
            hash[:invited_by_type] = nil
            hash[:invited_by_id] = nil
            u.update(hash)
            u.send_confirmation_instructions
            self.resource = u
        end
    end
end
