class AnswersController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]

  def new
    @topic = Topic.find(params[:topic_id])
  end

  def show
    @topic = Topic.find(params[:topic_id])
    @answer = Answer.find(params[:id])
  end

  def create
    topic = Topic.find(params[:topic_id])
    answer = current_user.answers.build(answer_params)

    if answer.save
      render json: { url: topic_answer_path(topic, answer) }
    else
      render json: { url: new_topic_answer_path(topic) }
    end
  end

  def edit
    @topic = Topic.find(params[:topic_id])
    @answer = current_user.answers.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:topic_id])
    @answer = current_user.answers.find(params[:id])

    if @answer.update(answer_params_for_update)
      redirect_to topic_answer_path(@topic, @answer), dark: (t 'defaults.message.updated', item: Answer.human_attribute_name(:description))
    else
      flash.now[:danger] = (t 'defaults.message.not_updated', item: Answer.human_attribute_name(:description))
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @answer = current_user.answers.find(params[:id])

    @answer.destroy
    redirect_to @topic, dark: (t 'defaults.message.deleted', item: Answer.model_name.human)
  end

  private

  def answer_params
    params.permit(:growl_voice, :description, :topic_id)
  end

  def answer_params_for_update
    params.require(:answer).permit(:description)
  end
end
