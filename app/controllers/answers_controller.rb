class AnswersController < ApplicationController
  before_action :require_login, only: %i[new]

  def new
    @topic = Topic.find(params[:topic_id])
  end

  def show
    @topic = Topic.find(params[:topic_id])
    @answer = Answer.find(params[:id])
  end

  def create
    topic = Topic.find(params[:topic_id])
    answer = current_user.answers.build(answer_params.merge(topic_id: topic.id))

    if answer.save
      render json: { url: topic_answer_path(topic, answer) }
    else
      render json: { url: new_topic_answer_path(topic) }
    end
  end

  private

  def answer_params
    params.permit(:growl_voice, :description)
  end
end
