APP_PATH = __dir__
require  "bundler"
Bundler.require
db = "#{APP_PATH}/db/test.sqlite"
File.delete(db) if File.exists? db
ChecklistApplication = Microframe::Application.new

require File.join(APP_PATH, "config", "routes")

APP = Rack::Builder.new do
  use Rack::MethodOverride
  run ChecklistApplication
end
