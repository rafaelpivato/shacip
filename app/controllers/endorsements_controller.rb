# frozen_string_literal: true

##
# Controller for endorsements resource
#
class EndorsementsController < ApplicationController
  # POST /endorsements
  def create
    user = User.find_by(email: endorsement_params[:email])
    if user.nil?
      render json: { data: { status: :unknown, user: nil } }, status: :created
    elsif user.validate_password(endorsement_params[:password])
      render json: { data: { status: :recognized, user: user.as_json } },
             status: :created
    else
      render json: { data: { status: :unknown, user: nil } }, status: :created
    end
  end

  private

  # Filter allowed params
  def endorsement_params
    params.permit(:email, :password)
  end
end
