class Api::InvitationsController < ApplicationController
    before_action :set_external_member
    skip_before_action :verify_authenticity_token

  
    def create
      if @external_member
        @invitation = @external_member.invitations.create
        if @invitation.save
          render json: { status: 'success', invite_link: invitation_url(@invitation.token) }, status: :created
        else
          render json: { status: 'error', errors: @invitation.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { status: 'error', message: 'External member not found' }, status: :not_found
      end
    end
  

    def accept
        @invitation = Invitation.find_by(token: params[:token])
        if @invitation
          # Handle the acceptance logic, e.g., update status or perform other actions
          @invitation.update(status: 'accepted')
          render json: { status: 'success', message: 'Invitation accepted' }, status: :ok
        else
          render json: { status: 'error', message: 'Invalid invitation token' }, status: :not_found
        end
      end
    private
  
    def set_external_member
      @external_member = ExternalMember.find_by(id: params[:external_member_id])
    end
  
    def invitation_url(token)
      "#{request.base_url}/invitations/#{token}/accept" 
    end
  end
  