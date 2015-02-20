class ExamQuestionsController < ApplicationController
	before_action :set_exam
	respond_to :html
	require 'json'
	def set_questions
   	 	$page_title = "Set Question"
    	@exam=Exam.find_by_id(@e_id)
	  	@e_id=params[:id]
		@questions=Question.order("correct_response_count/question_appeared_count DESC ,question_appeared_count DESC").all
		@max_id=Question.maximum(:id)

		@selected_questions = ExamQuestion.where(:exam_id=> @e_id.to_i).select("question_id")
		@selected_question_ids = []
		@selected_questions.each_with_index do |q, index|
			@selected_question_ids[index] = q.question_id
		end			
		respond_with(@questions,@e_id,@selected_question_ids,@exam, @max_id)
	end

	def save_exam_questions

		if params.has_key? "params"
			@exam=Exam.find_by_id(@e_id)            
            @res=true 

            puts params[:params].class

			@parameters= JSON.parse(params[:params])

			puts @parameters

			no_weightages=@parameters[0]["no_weightages"]
			weightages_json=@parameters[1]["weightages"]
			selected_questions=@parameters[3]["selectedque"]
			no_questions_each_weightage_json=@parameters[2]["no_questions_each_weightage"]

			puts no_weightages.class
			puts weightages_json.class
			

			no_weightages.times do |index|
				count=0
				x=weightages_json[index]["weightage"]
				y=no_questions_each_weightage_json[index]["no_questions"]
				selected_questions.length.times do |index1|
					q=Question.find(selected_questions[index1]["selectedq"])
					if q.weightage == x.to_i
					count=count+1
					puts count
					end
				end
				puts y
				puts count
				if count<y.to_i

					flash[:error]="Number of Questions for Weightage specified and number of questions selected do not match"
					@res=false	 					 			
				end			
			end
			if(@res)

				@exam.no_weightages=(no_weightages)
	        	@exam.weightages=JSON.generate(weightages_json)
	           	@exam.no_questions_each_weightage=JSON.generate(no_questions_each_weightage_json)
	           	@exam.total_marks=@parameters[4]["total_marks"]
	        	@exam.save
			
				ExamQuestion.where(:exam_id=> @e_id.to_i).destroy_all
				selected_questions.length.times do |index|			
					exam_ques= ExamQuestion.new 
					exam_ques.exam_id=@e_id.to_i
					exam_ques.question_id=selected_questions[index]["selectedq"]
					exam_ques.save
				end	
			end	
			
		end

		puts @res
	
		@res=@res.to_json
		respond_to do |format|
			format.html 
			format.json {render json: @res}
		end

	end



 	def view_exam_questions
    	$page_title = "Exam Questions"
 		query1 = ExamQuestion.where(:exam_id=> @e_id.to_i).select("question_id")
 		@exam_questions = Question.where("id in (?)", query1 )
 		respond_with(@exam_questions)
 	end

 	private
 	def set_exam
 		if user_signed_in?
	 		authorize! :manage, :site, :message => "Insufficient privileges to access the page"
		 	#@exam=Exam.find(params[:id])
		 	@e_id=params[:id]
		else
			authorize! :manage, :site, :message => "Please sign in first to access the page"
		end
	end
end



