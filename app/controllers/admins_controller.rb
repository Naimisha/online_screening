class AdminsController < ApplicationController
	before_action :authentication
	respond_to :html
	def index
		$page_title = "Add User"
	
	end

	def add_admin
 
		$page_title = "Add Admin"
		if !params[:admins].nil?
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
		  	puts @user.id
		  	p = Privilege.new
	      	p.user_id = @user.id
	      	p.role_id = Role.find_by_role_name("admin").id;
	      	p.save
	      	SendPassword.send_mail(params[:admins][:email],params[:admins][:first_name]+ params[:admins][:last_name],enc_password).deliver
	    	flash[:admin_added] = "Successfully admin added"
	    end
	end 
    $path=""
	  def add_users
	  	$page_title = "User Details"
	  	require 'spreadsheet'
	  	require 'digest/md5'

	  	name = Time.now.to_s  #params[:question][:image].original_filename
      	directory = "public/data"
      	$path = File.join(directory, name)
      	File.open($path, "wb"){|f| f.write(params[:admins][:userdata].read)}
	  	
	  	user_details=Spreadsheet.open($path);
	  	sheet1=user_details.worksheet('Sheet1');
	  	@users = []

	  	sheet1[0,8]="Generated Password"
	  	sheet1.each 1 do |row|

	  		password = row[7].to_s + Time.now.to_s
	  		enc_password = Digest::MD5.hexdigest(password)[0..9]
	  		user = [row[1]+" "+row[2], row[6], enc_password]
	  		@users.push(user)
	  	    u=User.create(:student_id => row[0],:first_name => row[1],:last_name => row[2],:phone_no => row[3],:degree => row[4],:passing_year => row[5],:email => row[6],:date_of_birth => row[7],:password => enc_password)

	  	    p = Privilege.new
      		p.user_id = u.id
      		p.role_id = Role.find_by_role_name("user").id;
      		p.save
      		SendPassword.send_mail(row[6],row[6],enc_password).deliver  
      		row[8]=enc_password
   		
	  	end
	    user_details.write $path+".xls"
	    respond_with(@users)
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
