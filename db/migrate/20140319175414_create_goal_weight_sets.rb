class CreateGoalWeightSets < ActiveRecord::Migration
  def change
    create_table :goal_weight_sets do |t|
      t.string :name

      t.timestamps
    end
  end
end
