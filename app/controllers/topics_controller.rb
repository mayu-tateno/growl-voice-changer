class TopicsController < ApplicationController
  def new
    @topic = current_user.topics.build
  end

  def create
    @topic = current_user.topics.build(topic_params)

    if @topic.save
      redirect_to root_path, dark: t('defaults.message.created', item: Topic.model_name.human)
    else
      flash.now[:danger] = t('defaults.message.not_created', item: Topic.model_name.human)
      render :new
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:body)
  end
end
