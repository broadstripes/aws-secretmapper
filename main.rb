require "logger"
require "json"
require "typhoeus"
require_relative "./controller"
require_relative "./lib/client"
require_relative "./lib/config"

logger = Logger.new(
  STDOUT,
  progname: "aws-parameter-store-secrets-controller",
  level: Config.fetch(:log_level, "DEBUG")
)
logger.info "starting up"

# handle shutting down immediately on second signal?
signals = Queue.new
%w[TERM INT].each do |sig|
  Signal.trap(sig) { signals << sig }
end

client = Client.new
secret_informer = nil
parametermapping_informer = nil
controller = Controller.new(logger, client, secret_informer, parametermapping_informer)

# secret_informer.start
# parametermapping_informer.start

controller.start

sig = signals.pop
logger.info "caught signal #{sig}, shutting down"
controller.stop
logger.info "bye"

exit 0
