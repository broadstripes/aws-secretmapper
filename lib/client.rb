class Client
  HOST = "localhost"
  PORT = "8001"

  private

  # req = Typhoeus::Request.new("localhost:8001/api/v1/watch/pods")
  # mappings_resp = Faraday.get('http://localhost:8001/apis/aws-parameter-store-secrets-controller.broadstripes.com/v1/parametermappings').body

  def consume_watch(request, queue)
    buffer = ""
    req.on_body do |chunk|
      buffer += chunk
      while (idx = buffer.index("\n"))
        item = JSON.load(buffer.slice!(0, idx + 1))
        # TODO: handle parsing failures
        queue << item
      end
    end
    # TODO: handle logging
    # TODO: handle request errors
    req.on_complete do |res|
      queue.close
    end
    req.run
  end
end
