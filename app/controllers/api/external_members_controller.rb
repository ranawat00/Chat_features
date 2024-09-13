class Api::ExternalMembersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
      @external_member = ExternalMember.new(external_member_params)
      if @external_member.save
        render json: @external_member, status: :created
      else
        render json: @external_member.errors, status: :unprocessable_entity
      end
  end

  def index
    @external_members = ExternalMember.all
    render json: @external_members
  end 

  def show
    @external_member = ExternalMember.find(params[:id])
    render json: @external_member
  end

  def update
    @external_member = ExternalMember.find(params[:id])
    if @external_member.update(external_member_params)
      render json: @external_member, status: :ok
    else
      render json: @external_member.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @external_member = ExternalMember.find(params[:id])
    @external_member.destroy
    head :no_content
  end
  
  private

  def external_member_params
    params.require(:external_member).permit(:name, :email) 
  end

end
