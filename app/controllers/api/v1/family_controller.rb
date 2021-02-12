class Api::V1::FamilyController < ApplicationController
    before_action :authenticate_user!
    def create
        begin
            family = PermissionsManager.create_family(current_user)
        rescue Exceptions::NoPermissionError
            render json: {}, status: 403
            return
        end
        render json: { 'family': family }, status: 200
    end
end
