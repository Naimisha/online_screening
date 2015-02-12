class WelcomeController < ApplicationController
 def index
 	puts 'welcome controller'
 	#render 'questions/index'
 	if user_signed_in?
 		$page_title = "Online Screening"
 		if can? :manage, :site
 			redirect_to :controller => 'admins', :action => 'index'
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
 	else
 		render "layouts/_homePage"
 	end
 end

end
