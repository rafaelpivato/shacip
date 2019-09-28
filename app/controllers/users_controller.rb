# frozen_string_literal: true

##
# Controller for users resource
#
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update]

  # GET /users
  def index
    @users = User.all

    render json: { data: @users }
  end

  # GET /users/1
  def show
    render json: { data: @user }
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: { data: @user }
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.permit(:email, :name, :nickname)
  end
end
