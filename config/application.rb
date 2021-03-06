require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bunny
  class Application < Rails::Application
#  config.paperclip_defaults = {
#    :storage => :s3,
#    :s3_protocol => 'http',
#    :bucket => ENV['AWS_BUCKET'],
#    :s3_credentials => {
#      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
#      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
#    },
#    :url => ':s3_domain_url',
#    :path => '/:class/:attachment/:id_partition/:style/:filename'
#  }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/lib) # add this line
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # the default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
