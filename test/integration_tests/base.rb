ENV["RACK_ENV"] = "test"

require_relative "../test_helper"
require "capybara"
require 'capybara/dsl'
require "sqlite3"
require "erb"
require "tilt"
require "tilt/erb"
require_relative "test_app/test"

class CapybaraTestCase < Minitest::Test
  include Capybara::DSL
  @@list_created = false
  @@item_created = false
  @@name = "Name for the checklist"
  @@item = "This is an item for this list"

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def setup_app
    Capybara.app = APP
  end

  def create_list
    return if @@list_created
    visit "/"
    click_link "New List"
    assert page.has_content? "New List"
    fill_in("list[name]", with: @@name)
    click_button "save"
    @@list_created = true
  end

  def create_item
    return if @@item_created
    visit "/"
    click_link @@name
    assert page.has_content? "Name: #{@@name}"
    click_link "Add item"
    assert page.has_selector? "form"

    fill_in("item[description]", with: @@item)
    click_button "save"
    @@list_created = true
    @@item_created = true
  end
end
