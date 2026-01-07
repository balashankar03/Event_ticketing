class EventsController < ApplicationController
  before_action :require_organizer, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:new, :create, :edit, :update, :destroy]
  


  def index
    if params[:query].present?
      @events=Event.search(params[:query]).order(datetime: :asc)
    else
      @events=Event.all.order(datetime: :asc)
    end
  end

  def show
  end

  def new
    @event=Event.new
    @venue=Venue.new
    3.times { @event.ticket_tiers.build }
  end

  def create
    @organizer=@user.userable
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
  @venue = @event.venue || Venue.new
  3.times {@event.ticket_tiers.build if @event.ticket_tiers.empty?}

  end

  def update

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
    @event.destroy
    redirect_to events_path, notice: "Event deleted successfully!"

  end


  

  private
  def require_organizer
    unless current_user&.organizer?
      redirect_to root_path, alert: "Only organizers can schedule an event"
      return
    end
  end

  def set_event
    @event =Event.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to events_path, alert: "Event not fount"
      return
  end

  def set_user
    @user = User.find(session[:user_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found"
    return
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
