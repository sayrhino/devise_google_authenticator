require 'rqrcode'
require 'base64'

module DeviseGoogleAuthenticator
  module Controllers # :nodoc:
    module Helpers
      def google_authenticator_qrcode(user, qualifier = nil, issuer = nil)
        username = username_from_email(user.email)
        app = user.class.ga_appname || Rails.application.class.parent_name
        data = "otpauth://totp/#{otpauth_user(username, app, qualifier)}?secret=#{user.gauth_secret}"
        data << "&issuer=#{issuer}" unless issuer.nil?
        qrcode = RQRCode::QRCode.new(data, level: :m, mode: :byte_8bit)
        png = qrcode.as_png(fill: 'white', color: 'black', border_modules: 1, module_px_size: 4)
        url = "data:image/png;base64,#{Base64.encode64(png.to_s).strip}"
        image_tag(url, alt: 'Google Authenticator QRCode')
      end

      def otpauth_user(username, app, qualifier = nil)
        "#{username}@#{app}#{qualifier}"
      end

      def username_from_email(email)
        /^(.*)@/.match(email)[1]
      end
    end
  end
end
