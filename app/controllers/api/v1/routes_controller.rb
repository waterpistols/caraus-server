class Api::V1::RoutesController < ApplicationController
  respond_to :json
  # before_action :authenticate_with_token!, only: [:update, :destroy]
  def index
    routes = Route.all

    if routes
      render json: routes, status: 200, root: false
    else
      render json: { errors: routes.errors }, status: 404
    end
  end

  def show
    route = Route.joins(:route_search_points).find(params[:id])

    if route
      render json: route, status: 200, location: [:api, route], root: false
    else
      render json: { errors: route.errors }, status: 404
    end
  end

  def create    
    route = Route.new(route_params)    
    
    if route.save
      if params[:route_search_points]
        search_points = params[:route_search_points]
        
        search_points.each do |sp|
          route_search_point = RouteSearchPoint.new
          route_search_point.latitude = sp[:latitude]
          route_search_point.longitude = sp[:longitude]
          route_search_point.route_id = route.id
          route_search_point.save
        end      
      end
      render json: route, status: 201, location: [:api, route], root: false
    else
      render json: { errors: route.errors }, status: 422
    end
  end

  def update
    route = Route.find(params[:id])
    
    if route.update(route_params)
      render json: route, status: 200, location: [:api, route]
    else
      render json: { errors: route.errors }, status: 422
    end
  end

  def destroy
    route = Route.find(params[:id])
    route.destroy
    head 204
  end

  private
    def route_params
      params.permit(:name, :start_longitude, :start_latitude, :destination_longitude, :destination_latitude, :description, :start_address, :destination_address, :distance, :duration)
    end

    def display_route(route)
      
    end
end
