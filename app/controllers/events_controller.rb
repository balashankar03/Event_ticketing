class EventsController < ApplicationController
  before_action :require_organizer, only: [:new, :create]
  def index
    @events=Event.all
  end

  def show
    @event=Event.find(params[:id])
  end

  def new
    @event=Event.new
    @venue=Venue.new


  end

  def create
    user=User.find(session[:user_id])
    @organizer=user.userable
    @event=Event.new(event_params)
    @event.organizer=@organizer
    
    if params[:event][:venue_id].present?
      @event.venue_id=params[:event][:venue_id]
    else
      @venue=Venue.new(venue_params)
      if @venue.save
      @event.venue = @venue
      else
      render :new and return
      end
    end

    if @event.save
      redirect_to @event, notice: "Event created successfully!"
    else
      @venue ||= Venue.new
      render :new, status: :unprocessable_entity
    end

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private
  def require_organizer
    unless session[:user_id] && session[:role]
      redirect_to root_path, alert: "Only organizers can schedule an event"
    end
  end

  def event_params
    params.require(:event).permit(:name, :description, :venue_id, :datetime)
  end

  def venue_params
    params.require(:venue).permit(:name, :address, :capacity, :city)
  end

end
