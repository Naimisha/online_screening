class QuestionsController < ApplicationController
  before_action :authentication

  respond_to :html
  require 'json'
  def index
    $page_title = "Question Pool"
    @questions = Question.all
    respond_with(@questions)
  end

  def show
    $page_title = "Question Details"
    @question =Question.find(params[:id])
    respond_to do |format|
      format.html { respond_with(@question) }
      format.json { render json: @question, :except => [:answer, :created_at, :updated_at]}
    end
  end

  def new
    $page_title = "Add Question"
    @question = Question.new
    respond_with(@question)
  end

  def edit
    $page_title = "Edit Question"
    @question = Question.find(params[:id])
    respond_with(@question)
  end

  def create
    @question = Question.new
    store_question
    respond_with(@question)
  end

  def update
    #@question.update(question_params)
    @question = Question.find(params[:id])
    store_question
    respond_with(@question)
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    respond_with(@question)
  end

  private
    def authentication     
        respond_to do |format|
          format.html { 
            if user_signed_in?
              authorize! :manage, :site, :message => "Insufficient privileges to access the page"
            else
              authorize! :manage, :site, :message => "Please sign in first to access the page"
            end
          }
          format.json {  }
        end
    
    end

    def question_params
      params.require(:question).permit(:question, :options, :answer, :weightage, :qtype, :nooptions, :image)
    end

    def store_question
      if params[:question].has_key? "image"
        upload_image
      else
        delete_image
      end
      qtype = params[:question][:qtype];
      if qtype == 'mcq'
        store_question_mcq
      elsif qtype == 'multi'
        store_question_multi
      elsif qtype == 'numerical'
        store_question_numerical
      end
    end

    def store_question_mcq
      answer = params[:ans].to_i
      no_options = params[:question][:nooptions].to_i
      options_json = '['
      ans_json = '['
      no_options.times do |i|
        options_json += '{"opt":"' + params["option#{i+1}"] + '"},'
        if i+1 == answer
          ans_json += '{"ans":"' + params["option#{answer}"] + '"},'
        end
      end
      options_json.chomp!(',')
      ans_json.chomp!(',')
      options_json += ']'
      ans_json += ']'
      params[:question][:options] = options_json
      params[:question][:answer] = ans_json
      @question.update(question_params)
      @question.save
    end

    def store_question_multi
      options_json = '['
      ans_json = '['
      no_options = params[:question][:nooptions].to_i
      no_options.times do |i|
        options_json += '{"opt":"' + params["option#{i+1}"] + '"},'
        if params.has_key? "ans#{i+1}"
          ans_json += '{"ans":"' + params["option#{i+1}"] + '"},'
        else
          ans_json += '{"ans":"#"},'
        end
      end
      options_json.chomp!(',')
      ans_json.chomp!(',') 
      options_json += ']'
      ans_json += ']'
      params[:question][:options] = options_json
      params[:question][:answer] = ans_json
      @question.update(question_params)
      @question.save
    end

    def store_question_numerical
      options_json = '[{"opt":"' + params["option#{1}"] + '"}]'
      ans_json = '[{"ans":"' + params["option#{1}"] + '"}]'
      params[:question][:options] = options_json
      params[:question][:answer] = ans_json
      @question.update(question_params)
      @question.save
    end

    def upload_image
      name = Time.now.to_s  #params[:question][:image].original_filename
      directory = "public/images"
      path = File.join(directory, name)
      File.open(path, "wb"){|f| f.write(params[:question][:image].read)}
      params[:question][:image] = name
    end

    def delete_image
      @question.image = ""
    end
end
