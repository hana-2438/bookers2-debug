class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :introduction
      t.string :image_id
      t.integer :owner_id
      t.references :user#referencesで他テーブルのuser（グループの作成者）を参照。作成者はグループに一人なので、別でリレーションを記述できる。
      t.timestamps
    end
  end
end
