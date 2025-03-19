class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :empty_recurring_for_once, only: %i[ create update ]
  before_action :set_event_until, only: :create

  def index
    @events = Event.in_period(starts_at, ends_at)
  end

  def new
    @event = Event.new(event_params)
    @event.color ||= "#404bad"
  end

  def show
    @date = Date.parse(params[:date])
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      turbo_notice("Success!")
    else
      render :edit
    end
  end

  def update
    if @event.update(event_params)
      turbo_notice("Success!")
    else
      render :edit
    end
  end

  def destroy
    if @event.destroy
      turbo_notice("Event was successfully destroyed.")
    end
  end

  private

  def starts_at
    I18n.l(params[:start]&.to_datetime || DateTime.current, format: :long)
  end

  def ends_at
    I18n.l(params[:end]&.to_datetime || 1.hour.from_now, format: :long)
  end

  def empty_recurring_for_once
    if params[:event][:every] == "once"
      Event::RECURRING_FIELDS.each { |f| params[:event].delete(f) }
      params[:event][:recurring] = nil
    end
  end

  def set_event_until
    return if event_params["event_until_id"].blank?

    @event_until = Event.find(event_params["event_until_id"])
    @event_until.update(until: event_params["start"].to_date - 1.day)
  end

  def turbo_notice(notice)
    render turbo_stream: turbo_stream.update('popup',
      ApplicationController.render(NoticeComponent.new(notice: notice))
    )
  end

  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:title, :start, :end, :color, :all_day, :parent_id, :recurring, :event_until_id,
      *Event::RECURRING_FIELDS
    )
  end
end
