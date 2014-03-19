# Activate the gem you are reporting the issue against.
gem 'activerecord', '4.0.4'
require 'active_record'
require 'minitest/autorun'
require 'logger'

# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :goal_weight_sets do |t|
    t.string :name

    t.timestamps
  end

  create_table :goal_weight_set_nutrients do |t|
    t.integer :nutrient_id
    t.boolean :index
    t.integer :goal_weight_set_id

    t.timestamps
  end
end

class GoalWeightSet < ActiveRecord::Base
  validates :name, :presence => true

  has_many :goal_weight_set_nutrients, :inverse_of=>:goal_weight_set, :dependent=>:destroy, :autosave=>true
end


class GoalWeightSetNutrient < ActiveRecord::Base
  belongs_to :goal_weight_set, :inverse_of=>:goal_weight_set_nutrients

  scope :model_weights, -> {where(:index=>false)}
  scope :model, -> {where(:index => false)}

end


first = GoalWeightSet.create!(:name => "First")
second = GoalWeightSet.create!(:name => "Second")

first.goal_weight_set_nutrients.create!(:nutrient_id => 1, :index => true)
first.goal_weight_set_nutrients.create!(:nutrient_id => 1, :index => false)


class GoalWeightSetNutrientTest < MiniTest::Unit::TestCase
  def test_model_scope
    first = GoalWeightSet.where(:name => "First").first
    assert_equal 1, first.goal_weight_set_nutrients.model.count

    second = GoalWeightSet.where(:name => "Second").first
    assert_equal 0, second.goal_weight_set_nutrients.model.count
  end
  def test_model_weights_scope
    first = GoalWeightSet.where(:name => "First").first
    assert_equal 1, first.goal_weight_set_nutrients.model_weights.count

    second = GoalWeightSet.where(:name => "Second").first
    assert_equal 0, second.goal_weight_set_nutrients.model_weights.count
  end
end
