class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  def create
    @trip = Trip.find(params[:trip_id])
    @task = Task.new(task_params)
    @task.trip = @trip
    if @trip.tasks.where(date: params[:task][:date]).first
      @task.user = @trip.tasks.where(date: params[:task][:date]).first.user
    else
      @task.user = current_user
    end
    @task.category = Category.find(params[:task][:category])
    if @task.save
      redirect_to trip_path(@trip)
    else
      render "trips/show", status: :unprocessable_entity
    end
  end

  def show
  end

  def update
    @trip = @task.trip

    @task.done = !@task.done

    if @task.save
      redirect_to trip_path(@trip)
    else
      render "trips/show", status: :unprocessable_entity
    end
  end

  def set_caretaker
    @trip = Trip.find(params[:trip_id])
    @tasks = @trip.tasks.where(date: params[:date])
    @tasks.each do |task|
      task.user = User.find(params[:user_id])
      task.save
    end
    redirect_to trip_path(@trip)
  end

  def destroy
    @trip = @task.trip
    @task.destroy
    redirect_to trip_path(@trip), status: :see_other
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :date)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
