class Api::V1::QuestionsController < Api::V1::BaseController
  include ApplicationHelper
  before_filter :checkTokenKeyParam, :except => ["create", "new", "index", "show", "edit", "update"]
  before_filter :validateTokenKey, :except => ["create", "new", "index", "show", "edit", "update"]
  before_filter :getUserByTokenKey, :only => [:send_answers, :question_of_the_day]
  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
  end

  #  #get question of the day old by asad
  #  def questionOfTheDay
  #    @question = Question.where(:expiry_date => Date.today())
  #    respond_to do |format|
  #      if !(@question.nil? || @question.count() == 0)
  #        #do something
  #        format.json {render json: {:success => true, :status_code => 200, :question => @question}}
  #        format.html {render json: {:success => true, :status_code => 200, :question => @question}}
  #        format.xml {render xml: {:success => true, :status_code => 200, :question => @question}}
  #      else
  #        format.json {render json: {:success => false, :status_code => 404, :message => "No question for today."}}
  #        format.html {render json: {:success => false, :status_code => 404, :message => "No question for today."}}
  #        format.xml {render xml: {:success => false, :status_code => 404, :message => "No question for today."}}
  #      end
  #    end
  #  end


  #by taimoor
  def question_of_the_day
    #    @question_answers =Admin::Question.where(:is_active => true).last
    @question_answers =Admin::Question.last
    respond_to do |format|
      if !@question_answers.blank? and !QuestionResult.find_by_question_id_and_user_id(@question_answers.id,@user.id).blank?
        params[:question_id] = @question_answers.id
        stat = get_stats
        format.json {render json: {:success => true, :status_code => 200, :message => 'You already submited answer(s)', :stats => stat, :question_answers => @question_answers}}
        format.html {render json: {:success => true, :status_code => 200, :message => 'You already submited answer(s)', :stats => stat, :question_answers => @question_answers}}
        format.xml  {render xml:  {:success => true, :status_code => 200, :message => 'You already submited answer(s)', :stats => stat, :question_answers => @question_answers}}
      elsif @question_answers.present?
        format.json {render json: {:success => true, :status_code => 200, :question_answers => @question_answers}}
        format.html {render json: {:success => true, :status_code => 200, :question_answers => @question_answers}}
        format.xml  {render xml:  {:success => true, :status_code => 200, :question_answers => @question_answers}}
      else
        format.json {render json: {:success => false, :status_code => 400, :message => "Not found question for Today."}}
        format.html {render json: {:success => false, :status_code => 400, :message => "Not found question for today."}}
        format.xml {render xml:   {:success => false, :status_code => 400, :message => "Not found question for today."}}

      end
    end
  end

  def not_exists?
    if QuestionResult.find_by_question_id_and_user_id(params[:question_id],@user.id).blank?
      return true
    else
      @message = "You already submited answer(s)"
      return false
    end
  end
  def get_stats
    #stats data gathering code starts
    question_answer = Admin::Question.find(params[:question_id])
    answers_arr = [question_answer.ans1, question_answer.ans2, question_answer.ans3,question_answer.ans4,question_answer.ans5]
    #         puts "answers_arr=====#{answers_arr.inspect}"

    stat = {}
    total_answers = question_answer.question_results.count
    answers_arr.each do |answer|
      result_count = question_answer.question_results.present? ? question_answer.question_results.where(:question_answer=> answer.to_s,:question_id => params[:question_id]).count : 0
      #             puts "#{answer.to_s} === result_count=#{result_count}  ===  answer_count#{total_answers}"
      percentage = (result_count/total_answers.to_f)*100
      percentage = percentage.to_i if percentage > 0
      stat.merge!({answer.to_s => "#{percentage}%" })
    end
    return  stat.merge!({:total_answers => total_answers})
  end
  def send_answers
    
    if check_params and not_exists?


      #saving answer results code start
      answers = remove_square_brackets(params[:answers]) if params[:answers].present?
      static_hash = { :question_id => params[:question_id], :user_id => @user.id}

      answers.each do |answer|
        question_results_hash= {:question_answer => answer.to_s}.merge(static_hash)
        QuestionResult.create(question_results_hash)
      end
      question_result = {:question_answer => answers}.merge(static_hash)
      flag = answers == QuestionResult.where(question_result).collect(&:question_answer).map(&:to_s) ? true : false
      #saving answer results code end

      stat = get_stats
    else
      stat = get_stats
      message = @message.present? ? @message : 'Required parameter(s) missing'
    end
    respond_to do |format|
      if flag
        
        format.json {render json: {:success => true, :status_code => 200, :message => 'Answered Saved Successfully', :stats => stat}}
        format.html {render json: {:success => true, :status_code => 200, :message => 'Answered Saved Successfully', :stats => stat}}
        format.xml  {render xml:  {:success => true, :status_code => 200, :message => 'Answered Saved Successfully', :stats => stat}}
      else
        message = message.present? ? message : "Unable to store Answers"
        format.json {render json: {:success => false, :status_code => 400, :message => message, :stats => stat }}
        format.html {render json: {:success => false, :status_code => 400, :message => message, :stats => stat }}
        format.xml {render xml:   {:success => false, :status_code => 400, :message => message, :stats => stat }}

      end
    end
    
  end

  def check_params
    params[:answers].present? and params[:question_id].present?
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to api_v1_question_path(@question), notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to api_v1_question_path(@question), notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to api_v1_questions_url }
      format.json { head :no_content }
    end
  end
end
