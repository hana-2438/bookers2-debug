class Relationship < ApplicationRecord
  # class_name: "User"でUserモデルを参照している
  #フォローしたユーザー
  belongs_to :follower, class_name: "User"
  #フォローされた
  belongs_to :followed, class_name: "User"
end
