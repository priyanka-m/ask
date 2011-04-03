#--
#   Copyright (C) 2011 Priyanka Menghani <priyanka.menghani@gmail.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

class QuestionsController < ApplicationController
  before_filter :authenticate_user!, :except => ["index", "show"]
  
  # GET /questions
  # GET /questions.xml
  def index
    @questions = Question.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.xml
  def show
    @question = Question.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.xml
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
    if !@question.user_editable?(current_user)
      flash[:notice] = 'This question is not editable by you'
      redirect_to root_url
    end
  end

  # POST /questions
  # POST /questions.xml
  def create
    @question = current_user.questions.build(params[:question])
    respond_to do |format|
      if @question.save
        format.html { redirect_to(@question, :notice => 'Question was successfully created.') }
        format.xml  { render :xml => @question, :status => :created, :location => @question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.xml
  def update
    @question = Question.find(params[:id])
    if !@question.user_editable?(current_user)
      flash[:notice] = 'This question is not editable by you'
      redirect_to root_url
    else
      respond_to do |format|
        if @question.update_attributes(params[:question])
          format.html { redirect_to(@question, :notice => 'Question was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @question.errors, :status => :unprocessable_entity }
        end
      end
    end  
  end

  # DELETE /questions/1
  # DELETE /questions/1.xml
  def destroy
    @question = Question.find(params[:id])
    if !@question.user_deletable?(current_user)
      flash[:notice] = 'This question is not editable by you'
      redirect_to root_url
    else
      @question.destroy
      respond_to do |format|
        format.html { redirect_to(questions_url) }
        format.xml  { head :ok }
      end
    end  
  end
  
  def upvote
    @question = Question.find(params[:question_id])
    @question.upvote_question
    redirect_to question_path(@question)
  end
  
  def downvote
    @question = Question.find(params[:question_id])
    @question.downvote_question
    @question.save
    redirect_to question_path(@question)
  end

end
