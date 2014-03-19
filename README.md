Why do these scope definitions have different behavior when used through an association
=================

I am working on upgrading to Rails 4 from Rails 3.  I have a scope definition that seems to be loosing the where clauses and other scopes that get applied.

I have these models:

```ruby
    class GoalWeightSet < ActiveRecord::Base
      has_many :goal_weight_set_nutrients, -> {order(:nutrient_id).includes(:nutrient)}, :inverse_of=>:goal_weight_set, :dependent=>:destroy, :autosave=>true
    end

    class GoalWeightSetNutrient < ActiveRecord::Base
      belongs_to :goal_weight_set, :inverse_of=>:goal_weight_set_nutrients

      scope :model_weights, -> {where(:index=>false)}
      scope :model, -> {where(:index => false)}
    end
```

I see radically different behavior between using these two scopes in Rails 4

```ruby
    # this is broken, it should have a where clause
    GoalWeightSet.first.goal_weight_set_nutrients.model.count
       (2.8ms)  SELECT COUNT(*) FROM "goal_weight_set_nutrients"
    => 37288

    # this is what I expect
    GoalWeightSet.first.goal_weight_set_nutrients.model_weights.count
       (0.4ms)  SELECT COUNT(*) FROM "goal_weight_set_nutrients" WHERE "goal_weight_set_nutrients"."goal_weight_set_id" = $1 AND "goal_weight_set_nutrients"."index" = 'f'  [["goal_weight_set_id", 8]]
    => 31
```

The ```scope :model``` works fine in Rails 3.  Why is this scope trying to load all the objects? Is there something special about a scope named 'model'?

Stack overflow question here:
http://stackoverflow.com/questions/22514068/why-do-these-scope-definitions-have-different-behavior-when-used-through-an-asso

