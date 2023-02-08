class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # DM機能のアソシエーション
  has_many :user_rooms
  # 閲覧数のアソシエーション
  has_many :read_counts, dependent: :destroy

  has_many :chats
  has_many :rooms, through: :user_rooms

  #group_userに対するアソシエーション
  has_many :group_users
  has_many :groups, through: :group_users, dependent: :destroy
  
  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy


  # フォロー機能のアソシエーション（フォローをした、されたの関係）
  #フォローした（class_nameでテーブルを渡す。foreign_keyでフォローした人を指定　）
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  #フォローされた（foreign_keyでフォローされた人を指定する）
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 一覧画面で使うアソシエーション
  #とあるフォローされたユーザーをフォローした人の一覧を中間テーブルを介して取得する（フォロワー一覧）
  has_many :followers, through: :reverse_of_relationships, source: :follower
  #とあるフォローしたユーザーにフォローされた人の一覧を中間テーブルを介して取得する（フォロー
  has_many :followings, through: :relationships, source: :followed
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  #　フォローした時の処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  #　フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  #　フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  # 検索方法の分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "pertial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end

end
