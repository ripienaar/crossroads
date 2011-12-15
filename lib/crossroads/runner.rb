module Crossroads
  class Runner
    attr_reader :router

    def initialize(configfile)
      defaults = {:configdir  => "/etc/crossroads",
                  :consume    => nil,
                  :logfile    => "/dev/stderr",
                  :loglevel   => :info,
                  :keeplogs   => 10,
                  :maxlogsize => 1024,
                  :daemonie   => false,
                  :stomp      => [{:server   => "localhost",
                                  :port     => 61613,
                                  :user     => nil,
                                  :password => nil}]}

      @config = defaults.merge(YAML.load_file(configfile))

      raise "Config file does not have input sources defined" unless @config[:consume]

      Log.configure(@config[:logfile], @config[:keeplogs], @config[:maxlogsize], @config[:loglevel])

      Log.info("Crossroads version #{Crossroads.version} starting with configfile #{configfile}")

      @router = Router.new(@config[:configdir])

      subscribe
      process
    end

    def process
      loop do
        begin
          msg = @stomp.receive

          targets = route(msg)

          targets.each do |target|
            Log.debug("Publishing to #{target[:target]}")
            @stomp.publish(target[:target], msg.body, msg.headers.merge({"crossroads_route" => target[:name]}))
          end
        rescue Interrupt
          break
        rescue Exception => e
          Log.error("Failed to consume from the middleware: #{e.class}: #{e}")

          sleep 1
          retry
        end
      end
    end

    def subscribe
      @stomp = Stomp.new(@config[:stomp])

      [@config[:consume]].flatten.each do |source|
        @stomp.subscribe source
      end
    end

    def route(msg)
      @router.route(msg)
    end
  end
end
