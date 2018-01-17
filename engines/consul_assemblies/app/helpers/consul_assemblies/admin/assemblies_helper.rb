module ConsulAssemblies
  module Admin::AssembliesHelper

    def geozones_select_options(geozones)
      geozones.map do |geozone|
        [geozone.name, geozone.id]
      end
    end

  end
end
