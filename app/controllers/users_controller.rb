class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_wing_admin, only: %i[create update]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to(user_url(@user), notice: I18n.t("notices.user.created")) }
        format.json { render(:show, status: :created, location: @user) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @user.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to(user_url(@user), notice: I18n.t("notices.user.updated")) }
        format.json { render(:show, status: :ok, location: @user) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @user.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url, notice: I18n.t("notices.user.destroyed")) }
      format.json { head(:no_content) }
    end
  end

  private

  CHECKED = "1"

  def set_wing_admin
    # This manipulation is necessary because by default a checkbox does not provide a value, if unchecked.
    # Therefore in the view we manually set string values for check and unchecked states.
    wing_admin_checked = params[:user][:wing_admin] == CHECKED
    @user.context = wing_admin_checked ? AircraftPolicy::WING_ADMIN_PERMISSION : ""
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :title, :company)
  end
end
