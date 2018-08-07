require 'rotp'

module Devise # :nodoc:
  module Models # :nodoc:
    module GoogleAuthenticatable
      def self.included(base) # :nodoc:
        base.extend ClassMethods

        base.class_eval do
          after_initialize :assign_auth_secret, if: ->() { self.persisted? && self.gauth_secret.blank? }

          include InstanceMethods
        end
      end

      module InstanceMethods # :nodoc:
        def get_qr
          gauth_secret
        end

        def set_gauth_enabled(param)
          update_attributes(gauth_enabled: param)
        end

        def assign_tmp
          update_attributes(gauth_tmp: ROTP::Base32.random_base32(32), gauth_tmp_datetime: DateTime.current)
          gauth_tmp
        end

        def validate_token(token)
          return false unless gauth_tmp_datetime
          return false if gauth_tmp_datetime < self.class.ga_timeout.ago

          ROTP::TOTP.new(get_qr).verify_with_drift(token, 30 * self.class.ga_timedrift.to_i, Time.current)
        end

        def gauth_enabled?
          if gauth_enabled.respond_to?("to_i")
            gauth_enabled.to_i != 0
          else
            gauth_enabled
          end
        end

        def require_token?(cookie)
          return true if self.class.ga_remembertime.nil? || cookie.blank?

          array = cookie.to_s.split ','

          return true if array.count != 2

          last_logged_in_email = array[0]
          last_logged_in_time = array[1].to_i
          last_logged_in_email != email || (Time.current.to_i - last_logged_in_time) > self.class.ga_remembertime.to_i
        end

        private

        def assign_auth_secret
          secret_key = ROTP::Base32.random_base32(64)
          update_attribute(:gauth_secret, secret_key) if gauth_secret.blank?
          self.gauth_secret = secret_key
        end
      end

      module ClassMethods # :nodoc:
        def find_by_gauth_tmp(gauth_tmp)
          where(gauth_tmp: gauth_tmp).first
        end

        ::Devise::Models.config(self, :ga_timeout, :ga_timedrift, :ga_remembertime, :ga_appname, :ga_bypass_signup)
      end
    end
  end
end
