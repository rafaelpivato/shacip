# frozen_string_literal: true

##
# Controller for accounts resource
#
class AccountsController < ApplicationController
  before_action :set_account, only: %i[show update]

  # GET /accounts
  def index
    @accounts = Account.all

    render json: { data: @accounts }
  end

  # GET /accounts/1
  def show
    render json: { data: @account }
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      render json: { data: @account }
    else
      render json: { errors: @account.errors }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def account_params
    params.permit(:name)
  end
end
