require "test_helper"
require "form_helper"
require "base"
require "mock_objects"

class FormHelperTest < Minitest::Test
  def setup
    @help = Microframe::FormHelper.new(Sample.new, "link_to_sample")
  end

  def test_start_form_without_default
    assert_equal "<form action='link_to_sample' method='post'>",
                 @help.start_form
    assert_equal 123, @help.target_id
    assert @help.form_started
  end

  def test_start_form_with_default
    @help2 = Microframe::FormHelper.new(Sample.new, nil)
    refute_equal "<form action='link_to_sample' method='post'>",
                 @help2.start_form
    assert_equal "<form action='/samples/123' method='post'>", @help2.start_form
    assert_equal 123, @help2.target_id
    assert @help2.form_started
  end

  def test_label_without_start_of_form
    assert_equal "<form action='link_to_sample' "\
    "method='post'><label >Name</label>", @help.label("Name")
  end

  def test_label_with_start_of_form
    @help.start_form
    assert_equal "<label >Name</label>", @help.label("Name")
  end

  def test_text_area_without_start_of_form
    assert_equal "<form action='link_to_sample' method='post'>"\
    "<textarea name = 'sample[id]' >123</textarea>", @help.text_area("id")
  end

  def test_text_area_with_start_of_form
    @help.start_form
    assert_equal "<textarea name = 'sample[id]' "\
    ">123</textarea>", @help.text_area("id")
  end

  def test_text_field_without_start_of_form
    assert_equal "<form action='link_to_sample' method='post'>"\
    "<input type = 'text' name = 'sample[id]' "\
    "value = '123' />", @help.text_field("id")
  end

  def test_field_with_start_of_form
    @help.start_form
    assert_equal "<input type = 'text' name = 'sample[id]' "\
    "value = '123' />", @help.text_field("id")
  end

  def test_submit_without_start_of_form
    assert_equal "<form action='link_to_sample' method='post'>"\
    "<input type = 'submit' value = 'save' /></form>", @help.submit
  end

  def test_submit_with_start_of_form
    @help.start_form
    assert_equal "<input type = 'hidden' name = '_method' value = 'put'/>"\
    "<input type = 'submit' value = 'save' /></form>", @help.submit
  end

  def test_checkbox_without_start_of_form
    assert_equal "<form action='link_to_sample' method='post'><input type = "\
    "'checkbox' name = 'sample[id]' checked = '123'  "\
    "value = 'true'/>", @help.check_box("id")
  end

  def test_checkbox_with_start_of_form
    @help.start_form
    assert_equal "<input type = 'checkbox' name = 'sample[id]' checked = '123'"\
    " class = 'something' value = "\
    "'true'/>", @help.check_box("id", class: "something")
  end

  def test_hidden_field_without_start_of_form
    assert_equal "<form action='link_to_sample' method='post'>"\
    "<input type = 'hidden' name = 'sample_id' value = "\
    "'123'/>", @help.hidden(Sample.new)
  end

  def test_hidden_field_with_start_of_form
    @help.start_form
    assert_equal "<input type = 'hidden' name = 'sample_id' "\
    "value = '123'/>", @help.hidden(Sample.new)
  end

  def test_gatekeeper
    output = "output"
    assert_equal "<form action='link_to_sample' method='post"\
    "'>#{output}", @help.gatekeeper(output)
    assert_equal output, @help.gatekeeper(output)
  end
end
