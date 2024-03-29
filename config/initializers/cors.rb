# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins 'example.com'
#
#     resource '*',
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
        origins 'localhost:4000'
        resource '/api/*', headers: :any, methods: [:get, :post, :patch, :put]
        resource '/login',
                 headers: :any,
                 methods: [:post],
                 expose: ['Authorization']
        resource '/signup',
                 headers: :any,
                 methods: [:post]
        resource '/invitation',
                 headers: :any,
                 methods: [:post, :put]
        resource '/ping-auth',
                 headers: :any,
                 methods: [:get]
        resource '/ping',
                 headers: :any,
                 methods: [:get]
    end
end
