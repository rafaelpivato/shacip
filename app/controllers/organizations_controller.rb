# frozen_string_literal: true

##
# Controller for organizations resource
#
class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show update]

  # GET /organizations
  def index
    @organizations = Organization.all

    render json: { data: @organizations }
  end

  # GET /organizations/1
  def show
    render json: { data: @organization }
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(organization_params)
      render json: { data: @organization }
    else
      render json: { errors: @organization.errors },
             status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = Organization.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def organization_params
    params.permit(:name)
  end
end
