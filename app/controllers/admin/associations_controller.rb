class Admin::AssociationsController < Admin::BaseController

  respond_to :html
  skip_before_filter :verify_authenticity_token

  def index
    @associations = Association.all.order("LOWER(name)")
  end

  def new
  end

  def edit
    @association = Association.find_by_id(params[:format])
  end


  def update
    @association = Association.find_by_id(params[:id])
    if params[:logo].present? && params[:fileContent]
      saveImage(params[:logo].split('.')[0] + Time.now.strftime("%d%m%Y%H%M")+ "." + params[:logo].split('.')[1], params[:fileContent])
      params[:logo] = params[:logo].split('.')[0] + Time.now.strftime("%d%m%Y%H%M")+ "." + params[:logo].split('.')[1]
      print params[:logo]
    else
      params[:logo] = "defaultLogoGetafe.png"
    end
    if @association.update(association_params)
      redirect_to admin_associations_path
    else
      render :edit
    end
  end

  def destroy
    print 'destroy '
    print params
    @association = Association.find_by_id(params[:format])
    if @association.destroy
      redirect_to admin_associations_path, notice: t('admin.associations.delete.success')
    else
      redirect_to admin_associations_path, flash: {error: t('admin.associations.delete.error')}
    end
  end

  def association_params
    if params.has_key?(:logo) && params[:logo].present?
      params.permit(:name, :description, :hidden, :geozones,:phone,:twitter_profile,:facebook_profile, :url, :address,:mail,:areas, :logo)
    else
      params.permit(:name, :description, :hidden, :geozones,:phone,:twitter_profile,:facebook_profile, :url, :address,:mail,:areas)
    end
  end

  def saveImage(filename, filecontent)

    dirname = File.dirname("#{Rails.root}/public/uploads/associationsLogo/#{filename}")
    Dir.mkdir(dirname) unless Dir.exist?(dirname)
    File.open(Rails.root.join(dirname, filename), 'wb') do |f|
      f.write(Base64.decode64(filecontent))
    end
  end

end
