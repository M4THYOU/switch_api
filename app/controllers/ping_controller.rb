class PingController < ApplicationController
    def index
        render nothing: true, status: :ok
    end
end
