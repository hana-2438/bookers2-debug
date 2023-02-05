class ChatsController < ApplicationController

  def show
    @user = User.find(params[:id])#チャットする相手が誰なのか
    rooms = current_user.user_rooms.pluck(:room_id)#ログイン中のユーザー（自分）の部屋情報をすべて取得し、roomsに代入
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)#find_byメソッドを使ってチャットする相手とのルームがあるか確認し、それをrser_roomsに代入する

    if user_room.nil?#共通のユーザールームがない場合
      # 新しくチャットルームを作る
      @room = Room.new
      @room.save
      # そのルームidを共通して持つ中間テーブルを、相手と自分の二人分作る
      UserRoom.create(user_id: @user.id, room_id: @room.id)
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
    else
      # 共通のチャットルームがあれば、それに紐づくroomを「@room」に代入する
      @room = user_room.room
    end
    # 「チャット履歴（@chats)の取得」「新規投稿用の空インスタンス(@chat)作成
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    # @chat = current_user.chats.new(chat_params)#ストロングパラメータを引数に@chatを作成
    # render :error unless @chat.save

    @chat = Chat.new(chat_params)
    # save状況に応じて返すビューを条件分岐する
    respond_to do |format|
      if @chat.save
        # format.html { redirect_to @chat }#htmlで返す場合、showアクションを実行し詳細ページを表示
        format.js#create.js.erbが呼び出される
      else
        # format.html { render :show }#htmlで返す場合、show.html.erbを表示
        format.js { render :errors }
      end
    end
  end



  private

  def chat_params
    params.require(:chat).permit(:message, :room_id).merge(user_id: current_user.id)
  end


end