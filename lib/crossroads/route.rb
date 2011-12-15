module Crossroads
  # expression "headers.foo = 1 and body.bar = 1"
  #
  # processor do |headers, body|
  #   target "/queue/foo" if body....
  # end
  class Route
    def initialize(name)
      @name = name
      @jgrep = JGrep::JGrep.new
      @expression = nil
      @processor = nil
      @route_count = 0
    end

    def load_route(file)
      Log.info("Loading route from file #{file} for router #{@name}")
      eval(File.read(file))
    end

    def route!(msg)
      @targets = []

      if @expression && @processor && @jgrep.match_value({"headers" => msg.headers, "body" => JSON.parse(msg.body)})
        @processor.call(msg.headers, msg.body)
      end

      @route_count += 1

      @targets
    end

    def target(trgt)
      @targets << {:target => trgt, :name => @name}
    end

    def processor(&blk)
      @processor = blk
    end

    def expression(exp)
      @expression = exp
      @jgrep.expression = exp
    end
  end
end
