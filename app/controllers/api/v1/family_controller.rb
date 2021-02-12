class Api::V1::FamilyController < ApplicationController
    before_action :authenticate_user!
    def create
        begin
            PermissionsManager.create_family(current_user)
        rescue Exceptions::NoPermissionError
            render json: {}, status: 403
            return
        end
        render json: { 'current_user': current_user }, status: 200
    end
end
