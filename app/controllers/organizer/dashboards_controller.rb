class Organizer::DashboardsController < ApplicationController
  def index
    @events=api_get('/events')
    render json: @events
  end
end
