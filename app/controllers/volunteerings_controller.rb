class VolunteeringsController < ApplicationController
  skip_authorization_check :only => [:home, :organization_voluteering, :voluntary_acts, :training_actions]
  skip_before_filter :verify_authenticity_token
@volunteeringActual
  def home
    @volunterlist = Volunteering.all.where('hidden = false').order("id")
    @volunteeringActual = Volunteering.all.where('hidden = false').order("id").first
    if params[:id].present? && !Volunteering.find_by_id(params[:id]).hidden
      @volunteeringActual = Volunteering.find_by_id(params[:id])
    end
    if @volunteeringActual.imagesGallery.present? && !@volunteeringActual.imagesGallery.nil?
      @photos = @volunteeringActual.imagesGallery.split(';')
    end
  end

  def organization_voluteering

  end

  def voluntary_acts

  end

  def training_actions

  end
end
