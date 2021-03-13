# frozen_string_literal: true

source 'https://rubygems.org'

group :development, :test do
  gem 'bson_ext', platforms: :ruby
  gem 'geoip'
  gem 'mongoid'
  gem 'rails', '~>5.1.0'
  gem 'rake'
  gem 'rubyzip'
  gem 'test-unit' # needed for Ruby >=2.2.0

  platforms :jruby do
    gem 'jgeoip'
    gem 'jruby-openssl'
  end

  platforms :rbx do
    gem 'rubysl', '~> 2.0'
    gem 'rubysl-test-unit'
  end
end

group :test do
  platforms :ruby, :mswin, :mingw do
    gem 'sqlite3', '~> 1.4.2'
    gem 'sqlite_ext', '~> 1.5.0'
  end

  gem 'webmock'

  platforms :ruby do
    gem 'mysql2', '~> 0.3.11'
    gem 'pg', '~> 0.11'
  end

  platforms :jruby do
    gem 'activerecord-jdbcpostgresql-adapter'
    gem 'jdbc-mysql'
    gem 'jdbc-sqlite3'
  end
end

gemspec
