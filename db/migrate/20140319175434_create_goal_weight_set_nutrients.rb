class CreateGoalWeightSetNutrients < ActiveRecord::Migration
  def change
    create_table :goal_weight_set_nutrients do |t|
      t.integer :nutrient_id
      t.boolean :index
      t.integer :goal_weight_set_id

      t.timestamps
    end
  end
end
