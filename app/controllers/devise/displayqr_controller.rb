class Devise::DisplayqrController < DeviseController
  prepend_before_action :authenticate_scope!, only: %i(show update refresh)

  include Devise::Controllers::Helpers

  def show
    if resource&.gauth_secret
      if !resource.gauth_enabled? && resource.gauth_secret.blank?
        resource.send(:assign_auth_secret)
        resource.save
      end

      @tmpid = resource.assign_tmp
      render :show
    else
      sign_in resource_class.new, resource
      redirect_to stored_location_for(scope) || :root
    end
  end

  def update
    if resource.gauth_tmp != params[resource_name]['tmpid'] ||
       !resource.validate_token(params[resource_name]['gauth_token'].to_i)
      set_flash_message(:error, :invalid_token)
      return render :show
    end

    if resource.set_gauth_enabled(params[resource_name]['gauth_enabled'])
      set_flash_message :notice, (resource.gauth_enabled? ? :enabled : :disabled)
      sign_in scope, resource, :bypass => true
      redirect_to stored_location_for(scope) || :root
    else
      render :show
    end
  end

  def refresh
    return redirect_to :root unless resource

    resource.send(:assign_auth_secret)
    resource.save

    set_flash_message :notice, :newtoken
    sign_in scope, resource, bypass: true
    redirect_to [resource_name, :displayqr]
  end

  private

  def scope
    resource_name.to_sym
  end

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end

  def resource_params
    params.require(resource_name.to_sym).permit(:gauth_enabled)
  end
end
