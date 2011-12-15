module Crossroads
  class Stomp
    attr_reader :subscriptions

    class EventLogger
      def on_connecting(params=nil)
        Log.info("Connection attempt %d to %s" % [params[:cur_conattempts], stomp_url(params)])
      rescue
      end

      def on_connected(params=nil)
        Log.info("Conncted to #{stomp_url(params)}")
      rescue
      end

      def on_disconnect(params=nil)
        Log.info("Disconnected from #{stomp_url(params)}")
      rescue
      end

      def on_connectfail(params=nil)
        Log.info("Connction to #{stomp_url(params)} failed on attempt #{params[:cur_conattempts]}")
      rescue
      end

      def on_miscerr(params, errstr)
        Log.debug("Unexpected error on connection #{stomp_url(params)}: #{errstr}")
      rescue
      end

      def stomp_url(params)
        "stomp://%s@%s:%d" % [params[:cur_login], params[:cur_host], params[:cur_port]]
      end
    end

    def initialize(config)
      connect(config)

      @subscriptions = []
    end

    def connect(config)
      hosts = []

      [config].flatten.each do |c|
        host = {}

        host[:host] = c[:server]
        host[:port] = c[:port]
        host[:login] = c[:user] if c[:user]
        host[:passcode] = c[:password] if c[:password]

        hosts << host
      end

      raise "No hosts defined for Stomp connection" if hosts.size == 0

      connection = {:hosts => hosts, :logger => EventLogger.new}

      @connection = ::Stomp::Connection.new(connection)
    end

    def subscribe(source)
      Log.info("Subscribing to #{source}")

      @connection.subscribe source
      @subscriptions << source
    end

    def unsubscribe(source)
      Log.info("Unsubscribing from #{source}")

      @connection.unsubscribe source
      @subscriptions.delete source
    end

    def publish(target, msg, headers)
      @connection.publish(target, msg, headers)
    end

    def receive
      @connection.receive
    end
  end
end
