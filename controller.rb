class Controller
  def initialize(logger, client, secret_informer, parametermapping_informer)
    @logger = logger
    @stop = false
  end

  def start
    @thread = Thread.new {
      until @stop
        @logger.debug "running controller loop"
        sleep 1
      end
    }
  end

  def stop
    @stop = true
    @thread.join
  end
end
