require_relative "../base"

class CreateListTest < CapybaraTestCase
  # i_suck_and_my_tests_are_order_dependent!

  def setup
    setup_app
  end

  def test_create_list
    create_list
    visit "/"
    assert page.has_content? @@name
  end

  def test_show_list_from_index
    create_list
    visit "/"
    click_link(@@name)
    assert page.has_content? "Name: #{@@name}"
  end

  def test_destroy_list
    create_list
    visit "/"
    click_button "Destroy"

    refute page.has_content? @@name
    @@list_created = false
  end

  def test_edit_list_from_index
    create_list
    @@name = "My New name"
    visit "/"
    click_link "Edit"
    assert page.has_selector? "form"

    within "form" do
      fill_in("list[name]", with: @@name)
      click_button "save"
    end
    visit "/"
    assert page.has_content? @@name
  end
end
