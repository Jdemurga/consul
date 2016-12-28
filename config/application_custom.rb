module Consul
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: 'consul.getafe.es' }
    config.i18n.available_locales = [:es] #GET-46 - Remove extra-locales
  end
end
