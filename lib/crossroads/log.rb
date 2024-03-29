module Crossroads
    class Log
        @configured = false

        class << self
            def log(msg, severity=:debug)
                configure unless @configured

                @logger.add(valid_levels[severity.to_sym]) { "#{from} #{msg}" }
            rescue Exception => e
                STDERR.puts("Failed to log: #{e.class}: #{e}: original log message: #{severity}: #{msg}")
                STDERR.puts(e.backtrace.join("\n\t"))
            end

            def configure(logfile, keep=10, maxsize=1024, level=:info)
                @logger = Logger.new(logfile, keep, maxsize)
                @logger.formatter = Logger::Formatter.new
                @logger.level = valid_levels[level.to_sym]
                @configured = true
            end

            # figures out the filename that called us
            def from
                from = File.basename(caller[4])
            end

            def valid_levels
                {:info  => Logger::INFO,
                 :warn  => Logger::WARN,
                 :debug => Logger::DEBUG,
                 :fatal => Logger::FATAL,
                 :error => Logger::ERROR}
            end

            def method_missing(level, *args, &block)
                super unless [:info, :warn, :debug, :fatal, :error].include?(level)

                log(args[0], level)
            end
        end
    end
end

