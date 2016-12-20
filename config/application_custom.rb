module Consul
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: 'consul.getafe.es' }
  end
end
