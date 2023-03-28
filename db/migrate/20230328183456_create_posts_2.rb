class CreatePosts2 < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.integer :author_id
      t.text :content

      t.timestamps
    end
  end
end
