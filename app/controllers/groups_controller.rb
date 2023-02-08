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

  def join
    @group = Group.find(params[:group_id])#Groupのidを@groupに代入する
    @group.users << current_user#「<<」は結合という意味。よって、@group.usersにcurrent_userを追加しなさいという記述
    redirect_to groups_path#グループ一覧へ遷移
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user#@group.user(新規作成したグループuser)にcurrent_userを追加する
    if @group.save
      redirect_to groups_path(@group)
    else
      render 'index'
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

  def destroy
    @group = Group.find(params[:id])
    @group.users.delete(current_user)#current_userは、@groupから消される
    redirect_to groups_path
  end


  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

end

