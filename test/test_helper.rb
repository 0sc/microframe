require "simplecov"
SimpleCov.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

path = File.join(__dir__,"..", "lib", "microframe")

Dir[File.join(path, "**")].each{ |file| $LOAD_PATH << file  }
require 'minitest/autorun'
require File.join(__dir__, "unit_tests", "utils.rb")

SampleRoutesWithPlaceholders =  {"PUT"=>{"/lists/:list_id/items/:id"=>{:controller=>"items", :action=>"update"}},
 "DELETE"=>
  {"/lists/:list_id/items/:id"=>{:controller=>"items", :action=>"destroy"}}}

SampleRoutesWithOptionals =  {"GET"=>
  {"/index/:id(/:di(/:ii(/params/:bb)))"=>
    {:controller=>"welcome", :action=>"articles"}}}

SampleRoutes = {"GET"=>
  {"/lists/new"=>{:controller=>"lists", :action=>"new"},
   "/lists/:id"=>{:controller=>"lists", :action=>"show"}},
 "PATCH"=>{"/lists/:id"=>{:controller=>"lists", :action=>"update"}}}

 class Minitest::Test
   include Utils
 end
