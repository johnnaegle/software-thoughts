# Activate the gem you are reporting the issue against.
gem 'activerecord', '4.0.4'
require 'active_record'
require 'minitest/autorun'
require 'logger'

# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.string :name

    t.timestamps
  end

  create_table :comments do |t|
    t.boolean :index
    t.integer :post_id

    t.timestamps
  end
end

class Post < ActiveRecord::Base
  validates :name, :presence => true

  has_many :comments, :inverse_of=>:post, :dependent=>:destroy, :autosave=>true
end


class Comment < ActiveRecord::Base
  belongs_to :post, :inverse_of=>:comments

  scope :not_index, -> {where(:index => false)}
  scope :model, -> {where(:index => false)}
end


first = Post.create!(:name => "First")
[true, false].each {|x| first.comments.create!(:index => x) }
second = Post.create!(:name => "Second")


class CommentTest < MiniTest::Unit::TestCase
  def test_model_scopea
    first = Post.where(:name => "First").first
    assert_equal 1, first.comments.model.count

    second = Post.where(:name => "Second").first
    assert_equal 0, second.comments.model.count
  end
  def test_not_index_scope
    first = Post.where(:name => "First").first
    assert_equal 1, first.comments.not_index.count

    second = Post.where(:name => "Second").first
    assert_equal 0, second.comments.not_index.count
  end
end
