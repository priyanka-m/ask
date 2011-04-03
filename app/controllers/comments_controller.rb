class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => ["index", "show"]
  
  def show
  end
  
  def new
  end
  
  def create
    @question = Question.find(params[:question_id])  
    params[:comment][:comment_poster_id] = current_user._id
    @comment = @question.comments.create!(params[:comment])
    redirect_to @question, :notice => "Comment created!" 
  end
  
  def edit
    @question = Question.find(params[:question_id])
    @comment = @question.comments.find(params[:id])
  end
  
  def update
    @question = Question.find(params[:question_id])
    @comment = @question.comments.find(params[:id])
    
    if @comment.user_editable?(current_user) and \
      @comment.update_attributes(params[:comment])
      flash[:notice] = 'Comment successfully updated.'
    else
      flash[:notice] = 'Problem with updating comment.'
    end
    redirect_to @question
  end
  
  def destroy
    @question = Question.find(params[:question_id])
    @comment = @question.comments.find(params[:id])
    
    if @comment.user_deletable?(current_user)
      @comment.destroy
      flash[:notice] = 'Comment successfully deleted.'
      redirect_to @question
    else
      flash[:notice] = 'Comment is not deletable by you.'
      redirect_to @question  
    end
  end
  
  def upvote
    @question = Question.find(params[:question_id])
    @comment = @question.comments.find(params[:comment_id])
    @comment.upvote_comment
    # TODO: Find out why it needs an explicit save to update the count
    @comment.save
    redirect_to question_path(@question)
  end
  
  def downvote
    @question = Question.find(params[:question_id])
    @comment = @question.comments.find(params[:comment_id])
    @comment.downvote_comment
    # TODO: Find out why it needs an explicit save to update the count
    @comment.save
    redirect_to question_path(@question)
  end
end
