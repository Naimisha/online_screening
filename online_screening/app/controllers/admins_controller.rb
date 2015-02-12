class AdminsController < ApplicationController
		before_action :authentication

	def index
		$page_title = "Add Admin"
		role_id=Role.select("id").find_by_role_name("user")
	 	query1 = Privilege.select("user_id").where("role_id in (?)",role_id)
		@user_data = User.where("id in (?)",query1)
	    @user_data = @user_data.to_json
	    
	    respond_to do |format|
	    	format.html
	    	format.json { render json: @user_data}
	    end
	  end

	  def make_admin
	  	@msg = "success"
	  	@msg= @msg.to_json
	  	@user_role_data = Privilege.all

	  	@var =  Privilege.find_by_user_id(params[:uid_cnt])
	  	role_id=Role.select("id").find_by_role_name("admin")
	  	puts role_id.id
	  	@var.role_id = role_id.id


	  	@var.save
	  	respond_to do |format|
	    	format.json { render json: @msg}
	    end
	  end 

	  private
		def authentication
			if user_signed_in?
				unless can? :manage, :site
					render "layouts/_notAnAdminError"
				end
			else
				render "layouts/_notSignedInError"
			end
		end	  
	end
