class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  before_filter :configure_permitted_parameters

  before_action :authentication, :only => [:index, :change_ip, :delete_user,:active_exam_users]

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

  def view_details
    @user=User.find(params[:id])
   respond_with(@user)
  end

  def index
    role=Role.find_by_role_name("user");
    privilege=Privilege.select("user_id").where("role_id = ?",role.id)
   
    if params[:college_name].nil?
      @users=User.all.where("id in (?)",privilege)
      @college_name="All Candidates"  
    else
      @users=User.all.where("id in (?) and college_name = ?",privilege,params[:college_name])
      @college_name="Candidates of "+params[:college_name]
    end
    @college_names=User.all.select("distinct college_name").where("college_name IS NOT NULL")
    respond_with(@users,@college_names,@college_name)
  end

  def active_exam_users
    exam =  Exam.select("id,exam_name, college_name").find_by_status("Activated")
    answersheet=exam.answer_sheets.select("user_id")
    @users=User.where("id in (?)",answersheet)
    @exam_name = exam.exam_name + " "+exam.college_name
    respond_with(@users,@exam_name)
  end

  def change_ip
    @answersheet=AnswerSheet.select("id,start_test_ip").find_by_user_id(params[:id])
    if params[:ip_address].nil?
      @user = User.select("id,first_name,last_name").find(params[:id])
      if @answersheet.nil?
        flash[:errors]="There is no answersheet for "+@user.first_name+" "+@user.last_name
      else
        respond_with(@user,@answersheet)
      end
    else
      @answersheet.start_test_ip=params[:ip_address]
      @answersheet.save
      flash[:sucess]="IP address updated to "+ params[:ip_address]
    end
  end

  def remove_user
    User.destroy(params[:id])
    flash[:success]="User is removed successfully" 
    redirect_to :action => "index"
  end

  def reset_password

      if !params[:confirm_password].nil?
        if params[:confirm_password]==params[:new_password]
          puts "reset_password"
          current_user.password = params[:confirm_password]
          current_user.save
          redirect_to root_path
        else
          flash[:error]="Password and confirm password must be same."
        end
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
  private
    def authentication
      if user_signed_in?
        authorize! :manage, :site, :message => "Insufficient privileges to access the page"
      else
        authorize! :manage, :site, :message => "Please sign in first to access the page"
      end
  end 
end
