class AnswersController < ApplicationController
  def new
    @topic = Topic.find(params[:topic_id])
  end

  def create
    topic = Topic.find(params[:topic_id])
    answer = current_user.answers.build(answer_params.merge(topic_id: topic.id))

    if answer.save
      render json: { url: root_url }
    else
      render json: { url: new_answer_path }
    end
  end

  private

  def answer_params
    params.permit(:growl_voice, :description)
  end
end
