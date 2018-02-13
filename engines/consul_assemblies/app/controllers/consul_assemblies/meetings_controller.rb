require_dependency "consul_assemblies/application_controller"

module ConsulAssemblies
  class MeetingsController < ApplicationController
    include CommentableActions
    skip_authorization_check

    helper_method :resource_model, :resource_name
    respond_to :html, :js

    def show
      @current_order = :newest
      scope = ConsulAssemblies::Meeting
      scope = scope.published unless @current_user && (@current_user.administrator?)
      @meeting = scope.find(params[:id])
      super
    end

    def set_meeting_votes(votes)

    end


    private

    def resource_model
      ConsulAssemblies::Meeting
    end

    def resource_name
      'meeting'
    end


  end
end
