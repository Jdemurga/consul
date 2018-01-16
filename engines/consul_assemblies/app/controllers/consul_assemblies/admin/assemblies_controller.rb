require_dependency "consul_assemblies/application_controller"

module ConsulAssemblies
  class Admin::AssembliesController < Admin::AdminController
    skip_authorization_check
    before_action :load_assemblies, only: [:index]

    def new
      @assembly = ConsulAssemblies::Assembly.new()
    end

    def index; end

    def create
      @assembly = ConsulAssemblies::Assembly.new(assembly_params)
      if @assembly.save
        redirect_to admin_assemblies_path, notice: t('admin.site_customization.pages.create.notice')
      else
        flash.now[:error] = t('admin.site_customization.pages.create.error')
        render :new
      end
    end


    private

    def load_assemblies
      @assemblies = ConsulAssemblies::Assembly.order(:name).page(params[:page] || 1)
    end

    def assembly_params
      params.require(:assembly).permit(
        :name,
        :general_description,
        :scope_description,
        :geozone_id,
        :about_venue,
        :created_at,
        :updated_at
      )
    end

  end
end
