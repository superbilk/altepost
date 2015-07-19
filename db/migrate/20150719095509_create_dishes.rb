class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :meal_id, null: false
      t.string :food_type
      t.string :name, null: false
      t.datetime :date
      t.string :image_url

      t.timestamps null: false
    end
    add_index :dishes, :meal_id, unique: true
  end
end
