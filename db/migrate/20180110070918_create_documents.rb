class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.string :author
      t.text :content
      t.references :user

      t.timestamps
    end
  end
end
