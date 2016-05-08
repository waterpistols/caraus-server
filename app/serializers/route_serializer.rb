class RouteSerializer < ActiveModel::Serializer
  attributes :id, :start_longitude, :start_latitude, :destination_longitude, :destination_latitude, :name, :description, :start_address, :destination_address, :distance, :duration, :route_search_points
end
