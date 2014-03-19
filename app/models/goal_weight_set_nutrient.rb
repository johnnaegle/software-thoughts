class GoalWeightSetNutrient < ActiveRecord::Base
  belongs_to :goal_weight_set, :inverse_of=>:goal_weight_set_nutrients

  scope :model_weights, -> {where(:index=>false)}
  scope :model, -> {where(:index => false)}

end
