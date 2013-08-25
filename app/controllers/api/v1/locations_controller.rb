module Api
  module V1
    class LocationsController < ApplicationController
      before_action :set_location, only: [:show, :edit, :update, :destroy]
      skip_before_filter :verify_authenticity_token
      respond_to :json
      
      # TODO: temporary for demo
      def index
        puts '----------------------------------'
        puts '--- locations / index ------------'
        puts '----------------------------------'
        
        # TODO: are params enough ? location_params ? create specific for index
        if params[:location][:session_id]
          puts 'asdasda=sd=as=a=sd=a=sd=a=sd=asd=a=sd=a=sd=as=da=s=d'
          puts 'asdasda=sd=as=a=sd=a=sd=a=sd=asd=a=sd=a=sd=as=da=s=d'
          puts 'asdasda=sd=as=a=sd=a=sd=a=sd=asd=a=sd=a=sd=as=da=s=d'
          puts 'asdasda=sd=as=a=sd=a=sd=a=sd=asd=a=sd=a=sd=as=da=s=d'
          respond_with Location.where(session_id: params[:location][:session_id]).first, :except => [:created_at, :updated_at]
        else
          respond_with Location.sorted, :except => [:created_at, :updated_at]
        end 
      end
      
      # GET /sessions/1
      def show
        puts '----------------------------------'
        puts '--- locations / show -------------'
        puts '----------------------------------'
      end
  
      # POST /sessions
      def create
        puts '----------------------------------'
        puts '--- locations / create -----------'
        puts '----------------------------------'
        
        # TODO: check if sender is the user who is sending the request
        
        begin
          @session = Session.find(location_params[:session_id])
        rescue ActiveRecord::RecordNotFound => e
          render :json => {  :error => "Session not found." }, :status => 404 # not found
          return
        end
        
        @existing_location = Location.where(session_id: location_params[:session_id]).first
        if @existing_location
          
          # update existing location
          @existing_location.update_attributes(lat: location_params[:lat], lon: location_params[:lon], bearing: location_params[:bearing])
          
          if @existing_location.save
            render :json => { :message => "Location updated." }, status: :ok # status works ?
          else
            render json: @existing_location.errors, status: :unprocessable_entity
          end
          
        else
          
          # create new location
          @location = Location.new(location_params)
          if @location.save
            render :json => { :message => "Location created." }, status: :created
          else
            render json: @location.errors, status: :unprocessable_entity
          end
          
        end
      end
      
      private
      
      # Use callbacks to share common setup or constraints between actions.
      def set_location
        begin
          @location = Location.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
          render :json => { :error => "Location not found." }, :status => 404 # not found
        end
      end
      
      # Never trust parameters from the scary internet, only allow the white list through.
      def location_params
        params.require(:location).permit(:session_id, :lat, :lon, :bearing)
      end
    end
  end
end