class Api::V1::ClusterController < ApplicationController
    before_action :authenticate_user!

    def index
        begin
            clusters = PermissionsManager.get_clusters(current_user)
        rescue
            render json: {}, status: 403
            return
        end
        render json: { 'clusters': clusters }, status: 200
    end

    # gets the things for a specific cluster
    def things
        begin
            things = PermissionsManager.get_cluster_things(current_user, things_params[:cluster_group_id])
        rescue
            render json: {}, status: 403
            return
        end
        render json: { 'things': things }, status: 200
    end

    def create
        begin
            family = PermissionsManager.create_family(current_user)
        rescue Exceptions::NoPermissionError
            render json: {}, status: 403
            return
        end
        render json: { 'family': family }, status: 200
    end

    private

    def things_params
        params.permit(:cluster_group_id)
    end

end
