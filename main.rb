#!/usr/bin/ruby

require "json"
require "sinatra"
require "sinatra/json"
require_relative "./syncer"

post "/sync" do
  observed = JSON.parse(request.body.read)
  logger.info "recieved state: #{JSON.generate(observed)}"
  desired = Syncer.new(observed).desired
  logger.info "desired state: #{JSON.generate(desired)}"
  json desired
end
