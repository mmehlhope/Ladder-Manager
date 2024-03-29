require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module LadderManager
  class Application < Rails::Application
    # Enable the asset pipeline
    config.assets.enabled = true
    # include web fonts
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
    config.secret_key_base = "0b319ed943a2a98ef65d405ca0a3a26a6f5503e8d41f275a6743ee060e87ea56acbada91e98ff3c74f54eed5a35ae6f898e4fc1d8f9cb03a23807d859d6de362"
    config.active_support.escape_html_entities_in_json = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    if defined? ::HamlCoffeeAssets
      config.hamlcoffee.placement = 'amd'
    end
  end
end

