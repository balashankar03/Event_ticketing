class Participant::DashboardsController < ApplicationController
  def index
    response = api_get('/events')
    puts "API Response Code: #{response.code}" 
    puts "API Body: #{response.body}"         

    @events = response.parsed_response
  end


end
