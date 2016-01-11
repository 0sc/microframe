require "simplecov"
SimpleCov.start
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require "minitest/autorun"
require "rack/test"
require File.join(__dir__, "unit_tests", "utils.rb")

module Minitest
  class Test
    include Utils
  end
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

path = File.join(__dir__, "..", "lib", "microframe")

Dir[File.join(path, "**")].each { |file| $LOAD_PATH << file }

SAMPLE_ROUTES_WITH_PLACEHOLDERS = {
  "PUT" => {
    "/lists/:list_id/items/:id" => { controller: "items", action: "update" }
  },
  "DELETE" => {
    "/lists/:list_id/items/:id" => {
      controller: "items", action: "destroy"
    }
  }
}

SAMPLE_ROUTES_WITH_OPTIONALS = {
  "GET" => {
    "/index/:id(/:di(/:ii(/params/:bb)))" => {
      controller: "welcome", action: "articles"
    }
  }
}

SAMPLE_ROUTES = {
  "GET" =>  {
    "/lists/new" => { controller: "lists", action: "new" },
    "/lists/:id" => { controller: "lists", action: "show" }
  },
  "PATCH" => {
    "/lists/:id" => { controller: "lists", action: "update" }
  }
}
