class Admin::VolunteeringsController < Admin::BaseController

  respond_to :html
  skip_before_filter :verify_authenticity_token

  def index
    @volunteering = Volunteering.all.order("LOWER(name)")
  end

  def new

  end

  def create
    print 'los params ->  '
    print params

    for i in 0..4
      @NamePhoto = "namePhoto#{i}"
      @Photo = "photo#{i}"
      if params[@NamePhoto].present?
        params[:imagesGallery] = ""
      end
    end

    for i in 0..4
      @NamePhoto = "namePhoto#{i}"
      @Photo = "photo#{i}"
      if params[@NamePhoto].present?
        if params[@Photo].present?
          params[@NamePhoto] = params[@NamePhoto].split('.')[0] + Time.now.strftime("%d%m%Y%H%M") + "." + params[@NamePhoto].split('.')[1]
          saveImage(params[@NamePhoto], params[@Photo])
        end
        if i == 4
          params[:imagesGallery] += params[@NamePhoto]
        else
          params[:imagesGallery] += params[@NamePhoto] + ";"
        end
      end
    end
    print 'imagesGalleryFinal -> '
    print params[:imagesGallery]
    object = Volunteering.new(:name => params[:name],:description => params[:description],:hidden => params[:hidden] ,:imagesGallery => params[:imagesGallery])
    object.save

    redirect_to '/admin/volunteerings'
  end

  def edit
    @volunteering = Volunteering.find_by_id(params[:format])
    if @volunteering.imagesGallery.present? && !@volunteering.imagesGallery.nil?
      @photos = @volunteering.imagesGallery.split(';')
    end
  end

  def update
    print 'los params son'
    print params["namePhoto0"]
    print " <-"
    @volunteeringSave = Volunteering.find_by_id(params[:id])

    for i in 0..4
      @NamePhoto = "namePhoto#{i}"
      @Photo = "photo#{i}"
      if params[@NamePhoto].present?
        params[:imagesGallery] = ""
      end
    end

    for i in 0..4
      @NamePhoto = "namePhoto#{i}"
      @Photo = "photo#{i}"
      if params[@NamePhoto].present?
        if params[@Photo].present?
          params[@NamePhoto] = params[@NamePhoto].split('.')[0] + Time.now.strftime("%d%m%Y%H%M") + "." + params[@NamePhoto].split('.')[1]
          saveImage(params[@NamePhoto], params[@Photo])
        end
        if i == 4
          params[:imagesGallery] += params[@NamePhoto]
        else
          params[:imagesGallery] += params[@NamePhoto] + ";"
        end
      end
    end

    if @volunteeringSave.update(volunteering_params)
      redirect_to admin_volunteerings_path
    else
      render :edit
    end
  end

  def volunteering_params
    params.permit(:name, :description, :hidden, :id, :imagesGallery)
  end

  def destroy
    print 'destroy '
    print params
    @volunteeringToDestroy = Volunteering.find_by_id(params[:format])
    if @volunteeringToDestroy.destroy
      redirect_to admin_volunteerings_path, notice: t('admin.volunteering.delete.success')
    else
      redirect_to admin_volunteerings_path, flash: {error: t('admin.volunteering.delete.error')}
    end
  end

  def saveImage(filename, filecontent)
    dirname = File.dirname("#{Rails.root}/public/uploads/volunteeringPhotos/#{filename}")
    Dir.mkdir(dirname) unless Dir.exist?(dirname)
    File.open(Rails.root.join(dirname, filename), 'wb') do |f|
      f.write(Base64.decode64(filecontent))
    end
  end

end
