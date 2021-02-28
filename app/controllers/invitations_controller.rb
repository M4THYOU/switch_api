class InvitationsController < Devise::InvitationsController

    # POST /resource/invitation
    def create
        family_group_id = params[:family_group_id]
        if family_group_id.nil?
            render json: {}, status: 400
            return
        end

        existing = false
        invitee = User.find_by(email: invite_params[:email])
        if invitee.nil?
            invitee = User.invite!(invite_params, current_inviter) do |u|
                u.skip_invitation = true
            end
        else
            existing = true
            invitee.invite!(current_inviter) do |u|
                u.skip_invitation = true
            end
        end

        user_invited = invitee.errors.empty?
        unless user_invited
            render json: { 'errors': invitee.errors }, status: 400
            return
        end

        begin
            PermissionsManager.invite_to_family(current_inviter, invitee, family_group_id)
        rescue Exceptions::NoPermissionError
            render json: {}, status: 403
            User.destroy!(invitee.id) unless existing
            return
        rescue Exceptions::RoleAlreadyExistsError
            render json: {'error': 'Role already exists'}, status: 400
            return
        end

        invitee.deliver_invitation
        render json: {}, status: 200
    end

    def update
        raw_invitation_token = update_params[:invitation_token]
        if raw_invitation_token.nil?
            render json: {}, status: 400
            return
        end

        invitee = User.accept_invitation!(update_params)
        invitation_accepted = invitee.errors.empty?
        unless invitation_accepted
            render json: { 'errors': invitee.errors }, status: 400
            return
        end

        render json: {}, status: 200
    end

    private

    def invite_params
        params.permit(:email)
    end

    def update_params
        params.permit(:first_name, :last_name, :password, :invitation_token)
    end

end

