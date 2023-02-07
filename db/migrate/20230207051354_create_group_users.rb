class CreateGroupUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_users do |t|
      # group_usersに外部キーとしてuser_idとgroup_idを登録している。referenceを使えば、自動でindexも引っ張ってくるので、index:trueは不要
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.timestamps
    end
  end
end
