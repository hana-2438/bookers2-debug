class ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show]#コントローラーの各アクションを行う前に、相互フォローか判断する
  
  def show
    @user = User.find(params[:id])#チャットする相手が誰なのか
    rooms = current_user.user_rooms.pluck(:room_id)#ログイン中のユーザー（自分）の部屋情報をすべて取得し、roomsに代入
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)#find_byメソッドを使ってチャットする相手とのルームがあるか確認し、それをrser_roomsに代入する
    
    unless user_rooms.nil?#ユーザールームはありましたか？
      @room = user_rooms.room#ルームがあった場合、@roomにユーザー（自分と相手）と紐づいているroomを代入する
    else#ユーザールームがなかった場合
      @room = Room.new#新しくルームを作成
      @room.save#保存する
      UserRoom.create(user_id: current_user.id, room_id: @room.id)#自分のUserRoomモデル作成
      UserRoom.create(user_id: @user.id, room_id: @room.id)#相手のUserRoomモデル作成
    end
    @chats = @room.chats#チャットの一覧用変数
    @chat = Chat.new(room_id: @room.id)#チャットの投稿用の変数
  end
  
  def create
    @chat = current_user.chats.new(chat_params)#
    render :validater unless @chat.save#もし、新規投稿が保存されなかった場合、validater.js.erbを探す。（非同期の使用）
  end
  
  
  
  private
  
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
  
  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
end