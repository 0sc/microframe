require_relative "base"

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

  def test_index_list_items
    create_list
    create_item

    visit "/lists/1000/items/"
    assert_equal "/lists", page.current_path
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

  def test_queries
    create_list
    create_item

    visit "/queries/a/b"
    assert_equal page.current_path, "/lists"

    visit "/queries/1/1"
    refute_equal page.current_path, "/lists"
    assert page.has_content? "This list has 1 item"
    assert page.has_content? "The name of the list this item belongs to is #{@@name}"
    assert page.has_content? "Total lists: 1"
    assert page.has_content? "Done status of first item: true"
    assert page.has_content? "And viola its changed Done status of first item: false"
    assert page.has_content? "@item.destroy: this destroys the item"
    @@item_created = false
  end
end
