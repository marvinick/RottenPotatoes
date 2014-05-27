class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  def self.all_ratings
    self.find(:all, :select => "rating", :group => "rating").map(&:rating)
  end
end
