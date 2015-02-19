class ExamsController < ApplicationController
	 before_action :authentication

  respond_to :html
 
  def index
    $page_title = "Upcoming Exams"
    @exams=Exam.all
    respond_with(@exams)
  end

  def new
    $page_title = "Add Exam"
  	@exam = Exam.new
  	respond_with(@exam)
  end

  def create
  	@exam = Exam.new(exam_params)
    @exam.status = "Deactivated"
  	@exam.save
  	respond_with(@exam)
  end

  def show
    $page_title = "Exam Details"
  	@exam=Exam.find(params[:id])
    respond_with(@exam)
  end

  def edit  
    $page_title = "Edit Exam"	
  	@exam=Exam.find(params[:id])
    respond_with(@exam)
  end

  def update
    @exam=Exam.find(params[:id])
  	@exam.update(exam_params)
  	@exam.save
  	respond_with(@exam)
  end

  def destroy
    @exam=Exam.find(params[:id])
    @exam.destroy
    respond_with(@exam)
  end

  def view_past_exams
    $page_title = "Past Exams"
    @exams=Exam.all
    respond_with(@exams)
  end

  def view_result
    if params[:id].nil?
        @exams=Exam.all
        respond_with(@exams)   
    else
        e=Exam.find(params[:id])
        @id=params[:id]
        @exam_name=e.college_name+"   " +e.exam_name
        @exams=Exam.all
      if params[:criteria].nil? 
        @result=AnswerSheet.where("exam_id = (?)",params[:id]).order("score DESC")  
      else       
          if params[:criteria]=="Marks"
            @result=AnswerSheet.where("exam_id = (?) AND score >= (?)",params[:id],params[:number]).order("score DESC")
            @exam_name += " , Those who get score more than "+params[:number]
          else 
           if params[:criteria]=="Ranks" 
              @result=AnswerSheet.where("exam_id = (?)",params[:id]).order("score DESC").take(params[:number])
              @exam_name+=" , Top "+params[:number]
            else
              @result=AnswerSheet.where("exam_id = (?)",params[:id]).order("score DESC")
            end 
          end
      end      
      respond_with(@result,@exam_name,@exams,@id)
    end
  end

  def toggle_exam_status
    @exam=Exam.find(params[:id])
    if @exam.status == "Activated"
      @exam.status = "Deactivated"
    else
      @exam.status = "Activated"
      Exam.where("id != (?)", params[:id]).update_all("status = 'Deactivated'")
    end
    @exam.save
    redirect_to :action => "index"
  end


  private
    def authentication
      if user_signed_in?
        authorize! :manage, :site, :message => "Insufficient privileges to access the page"
      else
        authorize! :manage, :site, :message => "Please sign in first to access the page"
      end        
    end

    def exam_params
      params.require(:exam).permit(:exam_name, :date, :time, :duration_mins, :college_name, :start_window_time, :end_window_time)
    end


end
