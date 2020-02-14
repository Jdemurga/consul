class CreateAssociations < ActiveRecord::Migration
  def change
    create_table :associations do |t|
      t.string :name
      t.text :description
      t.text :url
      t.string :phone
      t.string :title
      t.string :address
      t.string :twitter_profile
      t.string :facebook_profile
      t.string :mail
      t.text :externalURL
      t.string :logo
      t.text :areas
      t.text :geozones
      t.boolean :hidden, default: true
      t.timestamps null: false
    end
  end
end
