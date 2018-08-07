module DeviseGoogleAuthenticator
  module Generators
    class DeviseGoogleAuthenticatorGenerator < Rails::Generators::NamedBase
      namespace "devise_google_authenticator"

      desc "Add :google_authenticatable directive in the given model, plus accessors. Also generate migration for ActiveRecord"

      def inject_devise_google_authenticator_content
        path = File.join("app", "models", "#{file_path}.rb")

        return unless File.exist?(path)

        inject_into_file(path, "google_authenticatable, :", :after => "devise :")
        inject_into_file(path, "gauth_enabled, :gauth_tmp, :gauth_tmp_datetime, :", :after => "attr_accessible :")
        inject_into_class(path, class_name, "\tattr_accessor :gauth_token\n")
      end

      hook_for :orm
    end
  end
end
