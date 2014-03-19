require 'spec_helper'

describe GoalWeightSet do
  [:model, :model_weights].each do |scope|
    it "has the right values for #{scope}" do
      first = GoalWeightSet.create!(:name => "First")
      second = GoalWeightSet.create!(:name => "Second")

      first.goal_weight_set_nutrients.send(scope).count.should == 0
      second.goal_weight_set_nutrients.send(scope).count.should == 0

      first.goal_weight_set_nutrients.create!(:nutrient_id => 1, :index => true)
      first.goal_weight_set_nutrients.create!(:nutrient_id => 1, :index => false)

      # fails for :model with a count of 2
      first.goal_weight_set_nutrients.send(scope).count.should == 1
      second.goal_weight_set_nutrients.send(scope).count.should == 0
    end
  end
end
