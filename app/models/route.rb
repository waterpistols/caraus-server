class Route < ActiveRecord::Base
  has_many :route_search_points, dependent: :destroy
end
