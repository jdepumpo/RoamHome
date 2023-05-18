class TripsController < ApplicationController
  before_action :set_trip, only: %i[show edit update destroy]

  def index
    case current_user.role
    when "homeowner"
      @trips = Trip.where(user_id: current_user.id)
    when "caretaker"
      task_array = []
      Task.where(user_id: current_user.id).each { |task| task_array << task.trip }
      @trips = task_array.uniq
    else
      @trips = []
      "no trips yet"
    end
  end

  def new
    @trip = Trip.new
  end

  def show
    @task = Task.new
    @dates = ((Date.new(@trip.start_date.year, @trip.start_date.month, @trip.start_date.day))..(Date.new(@trip.end_date.year, @trip.end_date.month, @trip.end_date.day))).to_a
    @categories = Category.all
    caretaker_array = []
    @trip.tasks.each do |task|
      caretaker_array << task.user
    end
    @caretakers = caretaker_array.uniq
    case current_user.role
    when "homeowner"
      @tasks = @trip.tasks
    when "caretaker"
      @tasks = @trip.tasks.where(user_id: current_user)
    end
  end

  def edit
  end

  def update
    @trip.update(trip_params)
    if @trip.save
      redirect_to trip_path(@trip)
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    if @trip.destroy
      redirect_to trips_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user = current_user
    if @trip.save
      redirect_to trip_path(@trip)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :description, :start_date, :end_date, :location, :entry_description, :entry_type, :entry_key, :photo)
  end

  def set_trip
    @trip = Trip.new(trip_params)
  end
end
