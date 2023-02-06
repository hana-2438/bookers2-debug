class ChatsController < ApplicationController
  before_action :following_check, only: [:show]

  def show
    @user = User.find(params[:id])#①送られてきたidでuserを検索する
    rooms = current_user.user_rooms.pluck(:room_id)#②currrent_userの持つroom_idを取得
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)#①②を用いて合致するUserRoomがあるか探す
    if user_rooms.nil?#Roomが見つからなかった場合
      chat_room = Room.new#新しくRoomを作成
      chat_room.save
      UserRoom.create(user_id: current_user.id, room_id: chat_room.id)#自分のUserRoom作成。createは保存もしてくれるのでsave不要
      UserRoom.create(user_id: @user.id, room_id: chat_room.id)#相手のUserRoom作成。createは保存もしてくれるのでsave不要
    else
      chat_room = user_rooms.room#user_roomのroomの情報を抜き出してroomのidを取得する
      #roomはuserモデルで記載したhas_many :room, through: :user_roomsのroom
    end
    @chats = chat_room.chats#roomのidに合致するchatの内容を取得する
    #chatsはuserモデルで記載したhas_many :chatsのchats
    @chat = Chat.new(room_id: chat_room.id)#空のインスタンスの作成
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    # redirect_to request.referer　非同期のためredirect_toは消す。こうすることでcreate.js.erbを探しに行ってくれる
    chat_room = @chat.room#render処理と同じように値を渡す（roomのidを取得するための記述）
    @chats = chat_room.chats#render処理と同じように値を渡す（取得したroomのidをもとにchatの内容を取得する）
  end


  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def following_check
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end


end