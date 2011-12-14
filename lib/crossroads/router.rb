module Crossroads
  class Router
    def initialize(dir)
      raise "Cannot find routers directory #{dir}" unless File.directory?(dir)

      @routes = []
      @routesdir = dir

      loadroutes
    end

    def route(msg)
      targets = []

      @routes.each do |r|
        begin
          targets.concat(r.route!(msg))
        rescue
        end
      end

      targets
    end

    def routefiles
      Dir.entries(@routesdir).grep(/\.route$/).map do |f|
        File.join([@routesdir, f])
      end.sort
    end

    def loadroute(route)
      route_name = File.basename(route, ".route")

      r = Route.new(route_name)
      r.load_route(route)

      @routes << r
    rescue Exception => e
      STDERR.puts "Failed to load route #{route}"
      @routers.delete route_name rescue nil
    end

    def loadroutes
      routefiles.each do |route|
        loadroute route
      end
    end
  end
end
