# Load the Rails application.
require_relative "application"

# Load the app's custom environment variables here, so that they are loaded before environments/*.rb
env = File.join(Rails.root, 'config', 'env.rb')
load(env) if File.exist?(env)

# Initialize the Rails application.
Rails.application.initialize!
