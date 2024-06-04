class PilotsController < ApplicationController
  before_action :set_pilot, only: %i[ show edit update destroy ]

  # GET /pilots or /pilots.json
  def index
    @pilots = Pilot.all
  end

  # GET /pilots/1 or /pilots/1.json
  def show
  end

  # GET /pilots/new
  def new
    @pilot = Pilot.new
  end

  # GET /pilots/1/edit
  def edit
  end

  # POST /pilots or /pilots.json
  def create
    @pilot = Pilot.new(pilot_params)

    respond_to do |format|
      if @pilot.save
        format.html { redirect_to pilot_url(@pilot), notice: "Pilot was successfully created." }
        format.json { render :show, status: :created, location: @pilot }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pilot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pilots/1 or /pilots/1.json
  def update
    respond_to do |format|
      if @pilot.update(pilot_params)
        format.html { redirect_to pilot_url(@pilot), notice: "Pilot was successfully updated." }
        format.json { render :show, status: :ok, location: @pilot }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pilot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pilots/1 or /pilots/1.json
  def destroy
    @pilot.destroy!

    respond_to do |format|
      format.html { redirect_to pilots_url, notice: "Pilot was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pilot
      @pilot = Pilot.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pilot_params
      params.fetch(:pilot, {})
    end
end
