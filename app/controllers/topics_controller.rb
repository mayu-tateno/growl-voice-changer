class TopicsController < ApplicationController
  before_action :require_login, only: %i[new create]

  def new
    @topic = current_user.topics.build
  end

  def show
    @topic = Topic.find(params[:id])
    @pagy, @answers = pagy(Answer.where(topic_id: @topic.id).includes(:user).order(created_at: :desc))
  end

  def index
    @pagy, @topics = pagy(Topic.all.includes(:user).order(created_at: :desc))
  end

  def create
    @topic = current_user.topics.build(topic_params)

    if @topic.save
      redirect_to topics_url, dark: t('defaults.message.created', item: Topic.model_name.human)
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
