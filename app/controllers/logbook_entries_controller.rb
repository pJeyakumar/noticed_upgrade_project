class LogbookEntriesController < ApplicationController
  before_action :set_logbook_entry, only: %i[ show edit update destroy ]

  # GET /logbook_entries or /logbook_entries.json
  def index
    @logbook_entries = LogbookEntry.all
  end

  # GET /logbook_entries/1 or /logbook_entries/1.json
  def show
  end

  # GET /logbook_entries/new
  def new
    @logbook_entry = LogbookEntry.new
  end

  # GET /logbook_entries/1/edit
  def edit
  end

  # POST /logbook_entries or /logbook_entries.json
  def create
    @logbook_entry = LogbookEntry.new(logbook_entry_params)

    respond_to do |format|
      if @logbook_entry.save
        format.html { redirect_to logbook_entry_url(@logbook_entry), notice: "Logbook entry was successfully created." }
        format.json { render :show, status: :created, location: @logbook_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @logbook_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logbook_entries/1 or /logbook_entries/1.json
  def update
    respond_to do |format|
      if @logbook_entry.update(logbook_entry_params)
        format.html { redirect_to logbook_entry_url(@logbook_entry), notice: "Logbook entry was successfully updated." }
        format.json { render :show, status: :ok, location: @logbook_entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @logbook_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logbook_entries/1 or /logbook_entries/1.json
  def destroy
    @logbook_entry.destroy

    respond_to do |format|
      format.html { redirect_to logbook_entries_url, notice: "Logbook entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_logbook_entry
      @logbook_entry = LogbookEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def logbook_entry_params
      params.require(:logbook_entry).permit(:date, :departure_icao, :arrival_icao, :duration, :aircraft_id, :pilot_in_command_id, :second_in_command_id, :flt_training, :ground_training, :simulator, :cross_country, :time_of_day, :actual_instrument, :simulated_instrument, :day_landing, :night_landing, :single_engine_land, :multi_engine_land, :notes)
    end
end