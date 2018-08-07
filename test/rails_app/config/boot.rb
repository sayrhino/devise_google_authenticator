DEVISE_ORM = (ENV["DEVISE_ORM"] || :active_record).to_sym unless defined?(DEVISE_ORM)

begin
  require File.expand_path('../../../.bundle/environment', __dir__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup :default, :test, DEVISE_ORM
end
