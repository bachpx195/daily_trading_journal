class CreateBlogTag < ActiveRecord::Migration[5.2]
  def change
    create_table :blog_tags do |t|
      t.references :tag, foreign_key: true
      t.references :blog, foreign_key: true
      t.integer :blog_count
    end
  end
end
