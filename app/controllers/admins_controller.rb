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

	  def add_users
	  	require 'spreadsheet'
	  	
	  	user_details=Spreadsheet.open('/home/naimisha/user.xls');
	  	sheet1=user_details.worksheet('Sheet1');

	  	sheet1.each 1 do |row|
	  	    u=User.create(:student_id => row[0],:first_name => row[1],:last_name => row[2],:phone_no => row[3],:degree => row[4],:passing_year => row[5],:email => row[6],:date_of_birth => row[7],:password => row[7])

	  	    p = Privilege.new
      		p.user_id = u.id
      		p.role_id = Role.find_by_role_name("user").id;
      		p.save
      			SendPassword.send_mail(row[6],row[6],row[7]).deliver
      		
	  	end


	  end



	  private
		def authentication
			if user_signed_in?
				authorize! :manage, :site, :message => "Insufficient privileges to access the page"
				#unless can? :manage, :site
				#	render "layouts/_notAnAdminError"
				#end
			else
				authorize! :manage, :site, :message => "Please sign in first to access the page"
				render "layouts/_notSignedInError"
			end
		end	  
	end
