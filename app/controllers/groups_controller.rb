class GroupsController < ApplicationController
  # ユーザーがログインしているかアクションを開始する前に確認する
  before_action :authenticate_user!
  #投稿者以外のユーザーが投降者専用のページに遷移できないようにするための記述（URLの直打ち）
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def index
    @book = Book.new
    @groups = Group.all
  end
  
  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end
  
  def new
    @group = Group.new
  end 
  
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path
    else
      render 'new'
    end
  end
  
  def edit
    
  end
  
  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end
  
  
  private
  
  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end
  
  def ensure_correct_user
    @group = Group.find(arams[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
  
end

