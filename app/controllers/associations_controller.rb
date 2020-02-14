class AssociationsController < ApplicationController
  skip_authorization_check :only => [:index, :new, :show, :search, :create, :saveImage, :listAdmin]
  skip_before_filter :verify_authenticity_token

  def index
    @zones = Association.select("DISTINCT ON (geozones) *").where('hidden = false')
    print @zones

  end

  def new

  end

  def create
    print params
    if params[:filename].present? && params[:fileContent]
      saveImage(params[:filename].split('.')[0] + Time.now.strftime("%d%m%Y%H%M")+ "." +params[:filename].split('.')[1], params[:fileContent])
      params[:filename] = params[:filename].split('.')[0] + Time.now.strftime("%d%m%Y%H%M")+ "." +params[:filename].split('.')[1]
    else
      params[:filename] = "defaultLogoGetafe.png"
    end
    object = Association.new(:name => params[:name], :title => params[:name], :description => params[:description], :url => params[:url], :phone => params[:phone], :address => params[:address], :twitter_profile => params[:twitter_profile], :facebook_profile => params[:facebook_profile],
                             :mail => params[:mail], :geozones => params[:zone], :areas => params[:areasChecked], :logo => params[:filename])
    object.save

    redirect_to '/associative_spaces'
  end

  def show
    @association = Association.find_by_id(params[:q])
  end

  def search
    @zones = Association.select("DISTINCT ON (geozones) *").where('hidden = false')
    if !params[:zoneSelected].nil? and !params[:search].nil?

      print "busq1"
      @parameter = "%" + params[:search].downcase + "%"
      @zoneSelected = params[:zoneSelected]
      print "Lo buscado es : " + @parameter
      @results = Association.where("( name ILIKE ? or title ILIKE ? ) and hidden = false and geozones = ? ", @parameter, @parameter, @zoneSelected)

    elsif !params[:search].nil?

      print "busq2"
      @parameter = "%" + params[:search].downcase + "%"
      print "Lo buscado es : " + @parameter
      @results = Association.where("( name ILIKE ? or title ILIKE ? ) and hidden = false", @parameter, @parameter)

    elsif !params[:zoneSelected].nil?

      print "busq3"
      @zoneSelected = params[:zoneSelected]
      @results = Association.where("geozones = ? and hidden = false ", @zoneSelected)

    else
      return
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
