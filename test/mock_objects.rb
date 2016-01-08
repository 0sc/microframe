class Sample < Microframe::ORM::Base
  def params; end
  def view_rendered; end
  def render_view; end
  def path_info; end
  def host; end
  def id
    123
  end
  def cookies
    {}
  end
  def set_cookies; end
  def status=(arg); end
  def redirect(arg); end
  def write(arg); end
end
