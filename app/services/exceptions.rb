module Exceptions
    class NoPermissionError < StandardError; end  # 403
    class NoAuth < StandardError; end  # 401
    class AlreadyActivatedError < StandardError; end  # 400
end
