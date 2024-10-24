# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'sidekiq/testing' # Sidekiqの同期実行設定

# support ディレクトリのすべてのファイルを自動で読み込み
Pathname.glob(Rails.root.join('spec/support/**/*.rb')).each { |f| require f }

# ActiveRecordのマイグレーションを確認して適用
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # FactoryBotのメソッドを簡単に使えるようにする
  config.include FactoryBot::Syntax::Methods

  # Deviseのテストヘルパーを読み込み（コントローラとリクエストスペック用）
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Wardenのテストモードを有効化
  config.before(:suite) do
    Warden.test_mode!
  end

  # 各テスト後にWardenの状態をリセット
  config.after(:each) do
    Warden.test_reset!
  end

  # Fixtureのパスを設定
  config.fixture_path = Rails.root.join('spec/fixtures').to_s

  # トランザクションを使ったテストを有効化
  config.use_transactional_fixtures = true

  # ファイルのパスからテストタイプを自動的に判別
  config.infer_spec_type_from_file_location!

  # Railsのバックトレースを抑制
  config.filter_rails_from_backtrace!

  # 必要に応じて任意のGemのバックトレースもフィルタリング可能
  # config.filter_gems_from_backtrace("gem name")
end
