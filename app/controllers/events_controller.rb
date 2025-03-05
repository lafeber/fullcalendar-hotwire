class EventsController < ApplicationController
  before_action :set_event, only: %i[ edit update destroy ]
  before_action :empty_recurring_for_once, only: %i[ create update ]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/new
  def new
    @event = Event.new(start:, end:, color: '#404bad')
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_url, notice: "Event was successfully created." }
        format.turbo_stream { turbo_notice("Event was successfully created.") }
        format.json { render :edit, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to events_url, notice: "Event was successfully updated." }
        format.turbo_stream { turbo_notice("Event was successfully updated.") }
        format.json { render :edit, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.turbo_stream { turbo_notice("Event was successfully destroyed.") }
      format.json { head :no_content }
    end
  end

  private

  def start
    I18n.l(params[:start].to_datetime || DateTime.current, format: :long)
  end

  def end
    I18n.l(params[:end].to_datetime || 1.hour.from_now, format: :long)
  end

  def empty_recurring_for_once
    if params[:event][:every] == "once"
      Event::RECURRING_FIELDS.each { |f| params[:event].delete(f) }
      params[:event][:recurring] = nil
    end
  end

  # Use callbacks to share common setup or constraints between actions.

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
      params.require(:event).permit(:title, :start, :end, :color, :all_day, :recurring,
        *Event::RECURRING_FIELDS
      )
    end
end
