require_relative "../base"

class CreateItemsTest < CapybaraTestCase
  # i_suck_and_my_tests_are_order_dependent!

  def setup
    setup_app
  end

  def test_create_list_item
    create_list
    create_item

    visit "/"
    click_link @@name
    assert page.has_content? "Name: #{@@name}"
    assert page.has_content? @@item
  end

  def test_show_list_item
    create_list
    create_item
    visit "/"
    click_link @@name
    click_link "more >>"
    assert page.has_content? "list: #{@@name}"
    assert page.has_content? "description: #{@@item}"
  end

  def test_delete_list_item
    create_list
    create_item
    visit "/"
    click_link @@name
    click_link "more >>"
    assert page.has_content? "list: #{@@name}"
    assert page.has_content? "description: #{@@item}"

    click_button "Delete"
    @@item_created = false
    visit "/"
    click_link @@name
    refute page.has_content? @@item
  end

  def test_edit_list_item
    create_list
    create_item
    visit "/"
    click_link @@name
    click_link "more >>"
    assert page.has_content? "list: #{@@name}"
    assert page.has_content? "description: #{@@item}"
    click_link "Edit"

    @@item = "Another description"
    fill_in("item[description]", with: @@item)
    click_button "save"

    visit "/"
    click_link @@name
    assert page.has_content? @@item
  end
end
