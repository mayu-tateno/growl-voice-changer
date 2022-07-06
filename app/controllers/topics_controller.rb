class TopicsController < ApplicationController
  def new
    @topic = current_user.topics.build
  end

  def create
    topic = current_user.topics.build(topic_params)

    if topic.save
      redirect_to root_path, dark: 'お題を作成しました'
    else
      flash.now[:danger] = 'お題作成に失敗しました'
      render :new
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:body)
  end
end
