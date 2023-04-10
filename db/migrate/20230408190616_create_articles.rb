class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.references :topic, null: true, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.text :content, null: false
      t.string :article_url, null: false
      t.datetime :published_at, null: false
      t.string :image_url
      t.timestamps
    end
  end
end
