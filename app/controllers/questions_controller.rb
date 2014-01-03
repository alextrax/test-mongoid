require 'net/http'

class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.json
  def index
    #@questions = Question.all
    @myQuestions = current_user.questions
    @otherQuestions = Question.where(closed: false).ne(user: current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])

    @is_asker_or_follower = false;
    if @question.user == current_user || @question.followers.find(current_user)
      @is_asker_or_follower = true;
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @question }
    end
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
    #@question = Question.new(params[:question])
    @question = current_user.questions.new(params[:question])
    @question.closed = false

    respond_to do |format|
      if @question.save
        #receiver = User.ne(_id: current_user).to_a.first
        receivers = User.ne(_id: current_user).to_a
        #notification = receiver.question_notifications.create!(:question_url => question_path(@question))
        #notification_data = {:url => notification_path(notification, :type => :q), :type => :q}
        #message = {:channel => '/notifications/users/' + receiver._id, :data => notification_data.to_json.html_safe}

        messages = []
        receivers.each do |receiver|
          notification = receiver.question_notifications.create!(:question_url => question_path(@question))
          notification_data = {:url => notification_path(notification, :type => :q), :type => :q}
          messages.push({:channel => '/notifications/users/' + receiver._id, :data => notification_data.to_json.html_safe})
        end

        faye_uri = URI.parse("http://localhost:9292/faye")
        Net::HTTP.post_form(faye_uri, :message => messages.to_json)

        #format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.html { redirect_to root_path, notice: 'Question was successfully created.' }
        format.json { render json: @question, status: :created, location: @question }
        format.js
      else
        #format.html { render action: "new" }
        format.html { redirect_to root_path, notice: 'Question was not created...' }
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
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
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
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
end
