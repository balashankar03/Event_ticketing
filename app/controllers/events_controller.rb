class EventsController < ApplicationController
  before_action :require_organizer, only: [:new, :create, :edit, :update, :destroy]

  def index
    @events=Event.all
  end

  def show
    @event=Event.find(params[:id])
  end

  def new
    @event=Event.new
    @venue=Venue.new
    3.times { @event.ticket_tiers.build }
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
      redirect_to event_path(@event), notice: "Event created successfully!"
    else
      @venue ||= Venue.new
      render :new, status: :unprocessable_entity
    end

  end

  def edit
  @event = Event.find(params[:id])
  @venue = @event.venue || Venue.new
  3.times {@event.ticket_tiers.build if @event.ticket_tiers.empty?}

  end

  def update
    @event = Event.find(params[:id])

    if params[:event][:venue_id].present?
      @event.venue_id=params[:event][:venue_id]
    elsif venue_params_present?
      @venue=Venue.new(venue_params)
      if @venue.save
        @event.venue = @venue
      else
        render :edit and return
      end
    end

    if @event.update(event_params)
      redirect_to event_path(@event), notice: "Event updated successfully!"
    else
      @venue ||= @event.venue || Venue.new
      render :edit, status: :unprocessable_entity
    end

  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: "Event deleted successfully!"

  end

  private
  def require_organizer
    unless session[:user_id] && session[:role]=="organizer"
      redirect_to root_path, alert: "Only organizers can schedule an event"
    end
  end

  def event_params
    params.require(:event).permit(:name, :description, :venue_id, :datetime, :image, ticket_tiers_attributes: [:id, :name, :price, :remaining, :_destroy], category_ids: [])
  end

  def venue_params
    params.require(:venue).permit(:name, :address, :capacity, :city)
  end 

  def venue_params_present?
    params[:venue].values.any?(&:present?)
  end



end
