# config/initializers/sidekiq.rb
require 'sidekiq'
require 'sidekiq/scheduler'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/0' }

  config.on(:startup) do
    schedule_yaml = YAML.load_file(File.expand_path("../../../config/sidekiq.yml", __FILE__))
    Sidekiq.schedule = schedule_yaml[:scheduler][:schedule]
    Sidekiq::Scheduler.reload_schedule!
  end
end


Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

