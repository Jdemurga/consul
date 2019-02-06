class Admin::UsersController < Admin::BaseController
  load_and_authorize_resource

  before_action :load_users, only: [:index]

  def index
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data @users.to_csv}
    end
  end

  private

  def load_users
    if params[:search]
      s = params[:search]
      @users = User.where("username ILIKE ? OR email ILIKE ? OR document_number ILIKE ?", "%#{s}%", "%#{s}%", "%#{s}%")
      @users = User.where("newsletter = ?", params[:newsletter]) unless params[:newsletter].blank?
      @users = @users.page(params[:page])
      @params = params
    elsif params[:params_csv]
      s = params[:params_csv][:search]
      @users = User.where("username ILIKE ? OR email ILIKE ? OR document_number ILIKE ?", "%#{s}%", "%#{s}%", "%#{s}%")
      @users = User.where("newsletter = ?", params[:params_csv][:newsletter]) unless params[:params_csv][:newsletter].blank?
    else
      @users = @users.order(created_at: 'asc').page(params[:page])
    end
  end
end
