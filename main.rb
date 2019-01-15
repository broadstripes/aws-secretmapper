require "json"
require "sinatra"
require "sinatra/json"

post "/sync" do
  json out: "Howdy", p: params
end
