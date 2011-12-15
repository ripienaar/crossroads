module Crossroads
  class Router
    def initialize(dir)
      raise "Cannot find routers directory #{dir}" unless File.directory?(dir)

      @routesdir = dir
      @triggerfile = File.join(@routesdir, "reload.txt")
      @checktime = 0

      loadroutes
    end

    def reload_routes
      if (Time.now - @checktime).to_i > 30
        if File.exist?(@triggerfile)
          triggermtime = File::Stat.new(@triggerfile).mtime
          if triggermtime > @loadtime
            loadroutes
          end
        end

        @checktime = Time.now
      end
    end

    def route(msg)
      reload_routes

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
      @routes = []

      routefiles.each do |route|
        loadroute route
      end

      @loadtime = Time.now
    end
  end
end
