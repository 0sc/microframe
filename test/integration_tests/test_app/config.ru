APP_PATH = __dir__
require  "bundler"
Bundler.require

ChecklistApplication = Microframe::Application.new

require File.join(__dir__, "config", "routes")

use Rack::Reloader
use Rack::MethodOverride
run ChecklistApplication
