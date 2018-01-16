require_dependency "consul_assemblies/application_controller"

module ConsulAssemblies
  class Admin::ProposalsController < Admin::AdminController

    before_action :load_meeting, only: [:index]

    skip_authorization_check

    def index
      @proposals = @meeting ? @meeting.proposals : ConsulAssemblies::Proposal
      @proposals = @proposals.order(created_at: 'desc').page(params[:page] || 1)
    end

    def new
      @proposal = ConsulAssemblies::Proposal.new(meeting_id: params[:meeting_id])
    end

    def edit
      @proposal = ConsulAssemblies::Proposal.find(params[:id])
    end

    def update
      @proposal = ConsulAssemblies::Proposal.find(params[:id])
      if @proposal.update(proposal_params)
        redirect_to admin_proposals_path, notice: t('admin.site_customization.pages.create.notice')
      else
        flash.now[:error] = t('admin.site_customization.pages.create.error')
        render :new
      end
    end

    def create
      @proposal = ConsulAssemblies::Proposal.new(proposal_params)
      if @proposal.save
        redirect_to admin_proposals_path(meeting_id: @proposal.meeting_id), notice: t('admin.site_customization.pages.create.notice')
      else
        flash.now[:error] = t('admin.site_customization.pages.create.error')
        render :new
      end
    end

    def destroy
      @proposal = ConsulAssemblies::Proposal.find(params[:id])
      @proposal.destroy

      redirect_to admin_proposals_path
    end

    private

    def load_meeting
      @meeting = ConsulAssemblies::Meeting.find(params[:meeting_id]) if params[:meeting_id]
    end

    def proposal_params
      params.require(:proposal).permit(
        :meeting_id,
        :title,
        :description,
        :user_id,
        :accepted,
        :terms_of_service,
        :created_at,
        :updated_at
      )
    end

  end
end
