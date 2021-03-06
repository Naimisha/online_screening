class AdminsController < ApplicationController
	before_action :authentication
	respond_to :html
	def index
		$page_title = "Create Users"
	end

	def add_admin
		$page_title = "Add Admin"
		flash[:add_admin_message] = nil
		if !params[:admins].nil? 
		    if EmailVerifier.check(params[:admins][:email])
				require 'digest/md5'
				@user = User.new
				@user.first_name = params[:admins][:first_name]
				@user.last_name = params[:admins][:last_name]
				@user.phone_no = params[:admins][:phone_no]
				@user.date_of_birth = params[:admins][:date_of_birth]
				@user.email = params[:admins][:email]
				password = params[:admins][:date_of_birth].to_s + Time.now.to_s
			  	enc_password = Digest::MD5.hexdigest(password)[0..9]
			  	@user.password = enc_password
			  	u = @user.save
			  	
			  	if u
			  		p = Privilege.new
		      		p.user_id = @user.id
		      		p.role_id = Role.find_by_role_name("admin").id;
		      		if p.save
		      	   		SendPassword.send_mail_admin(params[:admins][:email],params[:admins][:first_name]+" " + params[:admins][:last_name],enc_password,current_user.first_name+" "+current_user.last_name).deliver
		    			flash[:add_admin_message] = "Successfully admin added"
		    		end
		    	else
		    		puts @user.errors.messages
		    	end
		    else
		    	flash[:add_admin_message] = "Specified Email Address does not exist"
		    end
	    end

		rescue Exception => e
			flash[:add_admin_message] = e.message
		end 

    $path=""

	  def add_users
	  	$page_title = "User Details"
	  	require 'spreadsheet'
	  	require 'digest/md5'
	  	if params[:admins].nil?
	  		flash[:error]="No file is selected"
	  		redirect_to  :action => "index"
	  	else
		  	if File.extname(params[:admins][:userdata].original_filename)==".xls"
			  	name = Time.now.to_s  #params[:question][:image].original_filename
		      	directory = "public/data"
		      	$path = File.join(directory, name)
		      	File.open($path, "wb"){|f| f.write(params[:admins][:userdata].read)}
			  	
			  	user_details=Spreadsheet.open($path);
			  	sheet1=user_details.worksheet('Sheet1');
			  	@users = []
			  	@users_not_created = []

			  	sheet1[0,8]="Generated Password"
			  	sheet1[0,9]="User created or not"
			  	sheet1.each 1 do |row|
					begin
				  		if EmailVerifier.check(row[6])

				  			password = row[7].to_s + Time.now.to_s
				  			enc_password = Digest::MD5.hexdigest(password)[0..9]
					  	    u=User.create(:student_id => row[0],:first_name => row[1],:last_name => row[2],:phone_no => row[3],:degree => row[4],:passing_year => row[5],:email => row[6],:date_of_birth => row[7],:password => enc_password, :college_name => params[:admins][:college_name])
				            
				            if u.valid?
				            	user = [row[1]+" "+row[2], row[6], enc_password]
				  				@users.push(user)
						  	    p = Privilege.new
					      		p.user_id = u.id
					      		p.role_id = Role.find_by_role_name("user").id;
					      		p.save
					      		SendPassword.send_mail_student(row[6],row[6],enc_password).deliver  
					      		row[8]=enc_password
					      		row[9]="Yes"   		
					      	else
					      		user_not_created = [row[1]+" "+row[2],row[6],"User already exist."]
					    		@users_not_created.push(user_not_created)
					    		row[9]="No"
					      	end
					    else
					    	user_not_created = [row[1]+" "+row[2],row[6],"Email address does not exist."]
					    	@users_not_created.push(user_not_created)
					    	row[9]="No"
					    end	
					rescue Exception => e
							user_not_created = [row[1]+" "+row[2],row[6],e.message]
					    	@users_not_created.push(user_not_created)
					    	row[9]="No"	
					end

			    end
		    		user_details.write $path+".xls"
		    		respond_with(@users,@users_not_created)
		    else
		    	flash[:error]="Sorry! Uploaded file is not in .xls format."
		    	redirect_to  :action => "index"		    	
		    end
		end
	  end
	  def download
	  	send_file $path+".xls"
	  end

	  private
		def authentication
			if user_signed_in?
				authorize! :manage, :site, :message => "Insufficient privileges to access the page"
			else
				authorize! :manage, :site, :message => "Please sign in first to access the page"
			end
		end	  
	end
