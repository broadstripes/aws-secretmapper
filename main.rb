require "json"
require "sinatra"
require "sinatra/json"
require_relative "./syncer"

post "/sync" do
  observed = JSON.parse(request.body.read)
  desired = Syncer.new(observed).desired
  json desired
end
