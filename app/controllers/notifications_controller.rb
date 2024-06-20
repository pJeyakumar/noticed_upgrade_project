class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[ show edit update destroy toggle_read ]

  # GET /notifications or /notifications.json
  def index
    @notifications = current_user.noticed_notifications.order(read_at: :desc)
  end

  # GET /notifications/1 or /notifications/1.json
  def show
  end

  # GET /notifications/new
  def new
    @notification = Noticed::Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end

  # POST /notifications or /notifications.json
  def create
    @notification = Noticed::Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to notification_url(@notification), notice: "Notification was successfully created." }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1 or /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to notification_url(@notification), notice: "Notification was successfully updated." }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1/toggle_read or /notifications/1/toggle_read.json
  def toggle_read
    @notification.read? ? @notification.mark_as_unread : @notification.mark_as_read

    respond_to do |format|
      format.html { redirect_to notifications_path(), notice: "Notification has been marked as #{@notification.read? ? "read" : "unread"}!" }
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy!

    respond_to do |format|
      format.html { redirect_to notifications_url, notice: "Notification was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Noticed::Notification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.fetch(:notification, {})
    end
end
