class WelcomeController < ApplicationController

 	
 def index
 	puts 'welcome controller'
 	
 	#render 'questions/index'
 	if user_signed_in?
 		$page_title = "Online Screening"
 		if can? :manage, :site
 			if current_user.sign_in_count == 1
 				redirect_to :controller => 'users/registrations', :action => 'reset_password'
 			else
 				redirect_to :controller => 'admins', :action => 'index'
 			end
 		else
 			puts current_user.sign_in_count
 			if current_user.sign_in_count == 1
 				redirect_to :controller => 'users/registrations', :action => 'reset_password'
 			else
 				@ans = AnswerSheet.find_by_user_id(current_user.id)
 				if @ans.nil?
 					redirect_to :controller => 'answer_sheets', :action => 'start_test'
 				else 
 					if @ans.score.nil? 
	 					redirect_to :controller => 'answer_sheets', :action => 'index'
 					else
 					 redirect_to :controller => 'answer_sheets', :action => 'show_result'
 					end
 				end
 			end 			
 		end
 	else
 		render "layouts/_homePage"
 	end
 end

end
