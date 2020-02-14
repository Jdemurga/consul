class CreateVolunteering < ActiveRecord::Migration
  def change
    create_table :volunteerings do |t|
      t.string :name
      t.text :description
      t.boolean :hidden , default: true
    end
  end
end
