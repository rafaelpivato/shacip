# frozen_string_literal: true

##
# Controller for registrations resource
#
class RegistrationsController < ApplicationController
  before_action :set_registration, only: %i[show update destroy]

  # GET /registrations
  def index
    @registrations = Registration.all

    render json: { data: @registrations }
  end

  # GET /registrations/1
  def show
    render json: { data: @registration }
  end

  # POST /registrations
  def create
    @registration = Registration.new(registration_create_params)

    if @registration.save
      render json: { data: @registration }, status: :created,
             location: @registration
    else
      render json: { data: @registration.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /registrations/1
  def update
    confirmed = registration_update_params[:confirmed]
    @registration.confirm!(confirmed) if confirmed
    render json: { data: @registration }
  end

  # DELETE /registrations/1
  def destroy
    @registration.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_registration
    @registration = Registration.find(params[:id])
  end

  # Creating and updating are different processes
  def registration_create_params
    params.permit(:organization_id, :email, :password, :params)
  end

  # You can only update "confirmed" flag
  def registration_update_params
    params.permit(:confirmed)
  end
end
