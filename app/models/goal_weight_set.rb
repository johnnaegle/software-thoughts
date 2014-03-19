class GoalWeightSet < ActiveRecord::Base
  validates :name, :presence => true

  has_many :goal_weight_set_nutrients, :inverse_of=>:goal_weight_set, :dependent=>:destroy, :autosave=>true
end
