class Comment < ActiveRecord::Base
  belongs_to :post, :inverse_of => :comments

  before_save do
    post.touch
  end
end
