class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  before_filter :configure_permitted_parameters

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:student_id, :first_name, :last_name, :phone_no, :degree, :passing_year, :date_of_birth, :registration_ip)
  end
  
  
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    if current_user != nil
      p = Privilege.new
      puts current_user.class
      p.user_id = current_user.id;
      p.role_id = Role.find_by_role_name("user").id;
      p.save;
    end
  end

  def view_profile
    @user=User.find(params[:id])
    respond_with(@user)
  end



  def reset_password

      if !params[:confirm_password].nil?
          puts "reset_password"
          current_user.password = params[:confirm_password]
          current_user.save
          redirect_to root_path
      end
    
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
