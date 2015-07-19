class CreateCalories < ActiveRecord::Migration
  def change
    create_table :calories do |t|
      t.integer :calories
      t.references :dish, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
