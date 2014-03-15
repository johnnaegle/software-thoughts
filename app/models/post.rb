class Post < ActiveRecord::Base
  has_many :comments, :dependent => :destroy, :inverse_of => :post

  accepts_nested_attributes_for :comments, :allow_destroy => true

  def self.hacking

    post = Post.create!

    post.attributes = {
      :comments_attributes => {
        "0" => {:body =>
          Lorem::Base.new('words', 50).output.split(" ").shuffle.join(' ')
        }
      }
    }
    puts "Updated at: #{post.updated_at.to_f}"
    sleep(5)
    post.save!
    puts "Updated at: #{post.updated_at.to_f}"
    post
  end
end
