module DeviseGoogleAuthenticator::Patches
  # patch Sessions controller to check that the OTP is accurate
  module CheckGA
    extend ActiveSupport::Concern

    included do
      alias_method :create_original, :create

      define_method :checkga_resource_path_name do |resource, id|
        name = resource.class.name.singularize.underscore
        name = name.split('/').last
        "#{name}_checkga_path(id:'#{id}')"
      end

      define_method :create do
        resource = warden.authenticate!(scope: resource_name, recall: "#{controller_path}#new")

        if resource.respond_to?(:get_qr) && resource.gauth_enabled? && resource.require_token?(cookies.signed[:gauth])
          tmpid = resource.assign_tmp
          warden.logout

          respond_with resource, :location => eval(checkga_resource_path_name(resource, tmpid))
        else
          set_flash_message(:notice, :signed_in) if is_flashing_format?
          sign_in(resource_name, resource)
          respond_with resource, :location => after_sign_in_path_for(resource)
        end
      end
    end
  end
end
