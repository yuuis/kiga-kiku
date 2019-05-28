require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/kiku'
require_relative '../apps/api/application'
require_relative '../apps/line_bot/application'

Hanami.configure do
  mount Api::Application, at: '/api'
  mount LineBot::Application, at: '/line_bot'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/kiku_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/kiku_development'
    #    adapter :sql, 'mysql://localhost/kiku_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  mailer do
    root 'lib/kiku/mailers'

    # See http://hanamirb.org/guides/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: http://hanamirb.org/guides/projects/logging
    logger level: :debug, stream: './Hanami.log'
  end

  environment :production do
    logger level: :info, formatter: :json, filter: []

    mailer do
      delivery :smtp, address: ENV.fetch('SMTP_HOST'), port: ENV.fetch('SMTP_PORT')
    end
  end
end
