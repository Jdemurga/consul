require_dependency "consul_assemblies/application_controller"

module ConsulAssemblies
  class Admin::MeetingsController < Admin::AdminController


    before_action :authenticate_user!
    before_action :load_assembly, only: [:index]
    before_action :load_assemblies, only: [:create, :new, :edit, :update]



    def act
      @meeting = ConsulAssemblies::Meeting.find(params[:id])
    end

    def new
      @meeting = ConsulAssemblies::Meeting.new(assembly_id: params[:assembly_id], user: current_user)
    end

    def edit
      @meeting = ConsulAssemblies::Meeting.find(params[:id])
    end

    def create
      @meeting = ConsulAssemblies::Meeting.new(meeting_params.merge(user: current_user))
      if @meeting.save
        redirect_to admin_meetings_path(assembly_id: @meeting.assembly_id), notice: t('.meeting_created')
      else
        flash.now[:error] = t('admin.site_customization.pages.create.error')
        render :new
      end
    end

    def destroy
      @meeting = ConsulAssemblies::Meeting.find(params[:id])
      @meeting.destroy

      redirect_to admin_meetings_path(assembly_id: @meeting.assembly_id), notice: t('.meeting_destroyed')
    end

    def update
      @meeting = ConsulAssemblies::Meeting.find(params[:id])
      if @meeting.update(meeting_params)
        redirect_to admin_meetings_path(assembly_id: @meeting.assembly_id), notice: t('.meeting_updated')
      else
        flash.now[:error] = t('admin.site_customization.pages.create.error')
        render :new
      end
    end


    def index
       @meetings = @assembly ? @assembly.meetings : ConsulAssemblies::Meeting
       @meetings = @meetings.order(scheduled_at: 'desc').page(params[:page] || 1)
    end

    private

    def load_assembly
      @assembly = ConsulAssemblies::Assembly.find(params[:assembly_id]) if params[:assembly_id]
    end

    def load_assemblies
      @assemblies = ConsulAssemblies::Assembly.order(:name)
    end

    def meeting_params
      params.require(:meeting).permit(
        :title,
        :summary,
        :description,
        :assembly_id,
        :status,
        :scheduled_at,
        :close_accepting_proposals_at,
        :about_venue,
        :published_at,
        :attachment,
        :comments_count,
        attachments_attributes: [:file, :title,:featured_image_flag, :_destroy, :id]
      )
    end
  end
end
