require "microframe/version"
require "bundler"
Bundler.require

require File.join(__dir__, "microframe", "orm", "connection")
require File.join(__dir__, "microframe", "application", "application")
