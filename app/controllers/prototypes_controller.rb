class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :check_authorization, only: [:edit]

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)

    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def index
    @prototypes = Prototype.includes(:user).order(created_at: :desc)
  end

def show
  @prototype = Prototype.find(params[:id])
  @comment = Comment.new
  @comments = @prototype.comments.includes(:user)
end

def edit
  @prototype = Prototype.find(params[:id])
end
  
def update
  @prototype = Prototype.find(params[:id])
  if @prototype.update(prototype_params)
    redirect_to prototype_path(@prototype), notice: ""
  else
    render :edit
  end
end

def destroy
  @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
end
end

private

def check_authorization
  @prototype = Prototype.find(params[:id])
  unless current_user == @prototype.user
    redirect_to root_path
  end
end

def prototype_params
  params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
end