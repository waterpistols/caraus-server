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

  def search
    start_longitude = params[:start_longitude] #firstPoint
    start_latitude = params[:start_latitude] #firstPoint

    destination_longitude = params[:destination_longitude] #secondPoint
    destination_latitude = params[:destination_latitude] #secondPoint

    latitude = 0.2
    longitude = 0.3

    # Create Square
    northest = start_latitude + latitude
    southest = start_latitude - latitude
    eastest = start_longitude + longitude
    westest = start_longitude - longitude


    routes = Route.joins(:route_search_points).where("route_search_points.latitude <= :northest AND route_search_points.latitude >= :southest AND route_search_points.longitude <= :eastest AND route_search_points.longitude >= :westest", northest: northest, southest: southest, eastest: eastest, westest: westest).all
    
    response = []

    distance_between_start_to_rsp = Float::INFINITY
    distance_between_destination_to_rsp = Float::INFINITY
    
    start_search_point = nil
    destination_search_point = nil

    routes.each do |route|
      search_points = route.route_search_points
      search_points.each do |rsp|
        # response.push(rsp)
        dbstr = Geocoder::Calculations.distance_between([start_latitude, start_longitude], [rsp.latitude, rsp.longitude], {:units => :km})
        dbdtr = Geocoder::Calculations.distance_between([destination_latitude, destination_longitude], [rsp.latitude, rsp.longitude], {:units => :km})

        if dbstr < distance_between_start_to_rsp
          start_search_point = rsp          
        end

        if dbdtr < distance_between_destination_to_rsp
          destination_search_point = rsp    
        end        
      end
      
      if start_search_point.id < destination_search_point.id
        response.push(route)
      end
    end

    render json: response, status: 200, root: false
  end

  private
    def route_params
      params.permit(:name, :start_longitude, :start_latitude, :destination_longitude, :destination_latitude, :description, :start_address, :destination_address, :distance, :duration)
    end
end
