class AnswerSheetsController < ApplicationController
	before_action :setAnswersheet, :except => :display_test
	before_filter :set_no_cache
  	
  	respond_to :html

	require 'json'
	def index
		unless @users_question.score.nil?
			redirect_to :action => 'show_result'
		else
			if request.remote_ip == @users_question.start_test_ip
				$page_title = "Exam"
				@question_collection = @users_question
				@countdown = @users_question.end_time - Time.now
				puts @countdown 
				respond_to do |format|
			    	format.html { respond_with(@addr,@countdown) }
			    	format.json { render json: @question_collection}
		    	end
	   		else
	   			flash[:errors]="You can not access exam from this machines"
	   		end
	    end
	end

	def edit
	end

	def update
		#@users_question.update(permitParams)
	end

	def update_result
		@message="success"
		@message = @message.to_json

		
			@result_params = JSON.parse(params[:answer])
			
		@res = @users_question.result
		
		@index=params[:id]
		@index = @index.to_i

		@res[@index] = @result_params
		#puts "Updated result = #{@res}"

		@users_question.result = @res
		@users_question.save
		
		respond_to do |format|
			format.json {render json: @message}
		end
	end

	def get_answer

		@result = @users_question.result
		
		@index=params[:id]
		@index = @index.to_i
		@ans = @result[@index]["answer"]
		
		respond_to do |format|
			format.json {render json: @ans}
		end

	end

	def show_result
		@score=0;
		@total=0;
		@given_ans=@users_question.result
	    for i in 0..@given_ans.length-1

	    	@ques_id=@given_ans[i]["question_id"]
	    	@question=Question.find(@ques_id)
	    	@question.question_appeared_count += 1
	    	@correct_answer=@question.answer
	    	@total+=@question.weightage    	
	    	@given_answer=@given_ans[i]["answer"]

	    	if @correct_answer == @given_answer
	    		@score+=@question.weightage
	    		@question.correct_response_count+=1
	    	end
	    	@question.save 	   		
	    end

	    @users_question.score=@score
	    @users_question.save	
	end

	def display_test
		$page_title = "View AnswerSheet"
		@users_question="";
		if can? :manage,:site
			puts params[:id]
			@users_question = AnswerSheet.find_by_user_id(params[:id]);
			puts @users_question.nil?
		else
			@users_question = AnswerSheet.find_by_user_id(current_user.id);
		end


		@answers = @users_question.result
		
		@review="["
		for i in 0..@answers.length-1
			@ques_id=@answers[i]["question_id"]
			@quest=Question.find(@ques_id)
			@review=@review+"{\"question\":\""+@quest.question+"\", \"answer\":\""
			if @answers[i]["answer"]==""
				@review+="\"},"
			else
				@curr_ans = JSON.parse(@answers[i]["answer"])
				for j in 0..@curr_ans.length-1
					if @curr_ans[j]["ans"] != "#"
						@review += @curr_ans[j]["ans"] 
						@review += ","
					end
					
				end
				@review.chomp!(',')
				@review+="\"},"			
			end	
		end
		@review.chomp!(',')
		@review=@review+"]"
		puts @review
		@review=JSON.parse(@review)
  		@id=@users_question.user_id
		respond_to do |format|
			format.html {respond_with (@id)}
			format.json {render json: @review}			
		end
	end

	def show
			@question =Question.find(params[:id])
			respond_to @question
	end

	def start_timer

		if @users_question.nil?
			@exam=Exam.find_by_status("Activated");
				
			if !@exam.nil? 
					no_of_weightage=@exam.no_weightages
					no_of_question_per_weightage=JSON.parse(@exam.no_questions_each_weightage)
					weightages=JSON.parse(@exam.weightages)
				   	question_id= ExamQuestion.where(:exam_id=> @exam.id).select("question_id");
	            	selected_questions=[]
					for i in 0..weightages.length-1
							questions=Question.select("id").where("id in (?) AND weightage = (?)", question_id,weightages[i]['weightage'])
				            questions=questions.shuffle
				            len=no_of_question_per_weightage[i]["no_questions"].to_i-1
				           	selected_questions += questions[0..len]
				    end				
				    answer_str="["
				    result_str="["
				    for i in 0..selected_questions.length-1
				    	answer_str += '{"id": ' + (i+1).to_s + ', "question_id": ' + selected_questions[i]["id"].to_s + '},'
				    	result_str += '{"question_id":'+selected_questions[i]["id"].to_s+',"answer":""},'
				    end
				    answer_str.chomp!(',')
				    answer_str+="]"
				   
				    result_str.chomp!(',')
				    result_str+="]"
				   
				    @user_answersheet=AnswerSheet.new
				    @user_answersheet.answer=JSON.parse(answer_str)
				    @user_answersheet.result=JSON.parse(result_str)
				    @user_answersheet.user_id=current_user.id
				    @user_answersheet.exam_id=@exam.id
				    @user_answersheet.start_test_ip=request.remote_ip
				    @user_answersheet.start_time = Time.now
					@exam = Exam.find(@user_answersheet.exam_id)
					d = Date.parse(@exam.date.to_s)
					t1= Time.parse(@exam.end_window_time.to_s)
					t2 = Time.mktime(d.year, d.mon, d.mday, t1.hour, t1.min)
					@user_answersheet.end_time = [Time.now + @exam.duration_mins.minutes, t2].min
					@user_answersheet.save
					puts @user_answersheet.end_time
					redirect_to :action => "index"
				    
			else
					flash[:errors]="No exam is Active Now"
			end
		else
			redirect_to :action => "index"
		end

		
		
	end

		
	def start_test
	
		
	end

	def set_no_cache
		response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
		response.headers["Pragma"] = "no-cache"
		response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
	end

	# def start_exam
	# 	@exam = Exam.find(1)
 # 		if Timer.where(:exam_id => @exam.id, :user_id => current_user.id).empty?
 #   			@now = DateTime.now
 #  			@end = @now + @exam.duration_mins.minutes
 #  			@time = Timer.create(:exam_id => @exam.id, :user_id => current_user.id, :start_exam => @now, :end_timing_exam => @end, :finished => false)
 # 		else
 # 		puts @exam.duration_mins
 # 		puts current_user.id
 #   		@time = Timer.where(:exam_id => @exam.id, :user_id => current_user.id).find(1)
 #   		puts "hheeeeeeeeeeeeee"
 #   		puts @time.end_timing_exam
 # 		end
 # 		puts @exam 
	# end

	# def end_exam
	# 	@c_user = current_user
	# 	puts @c_user.id
	# 	@tm = Timer.where(:user_id => @c_user.id).find(1)
	# 	puts @tm.end_timing_exam
	# 	@tm.finished = 1
	# 	@tm.save
	# 	#render :end_exam
	# end
	
	private
	def permitParams
		params.require(:answersheet).permit(:result)
	end

	def setAnswersheet
		if user_signed_in?
			authorize! :appear, :exam, :message => "Not authorized to appear in exam"
			@users_question = AnswerSheet.find_by_user_id(current_user.id);
		else
			authorize! :appear, :exam, :message => "Please sign in first to access the page"
		end
	end
end
