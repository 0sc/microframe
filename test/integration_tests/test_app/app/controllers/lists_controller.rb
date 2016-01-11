class ListsController < Microframe::ApplicationController
  def index
    @lists = List.all
    render view: "index"
  end

  def show
    set_list
    if @list
      @items = @list.items.all
    else
      redirect_to "/lists"
    end
  end

  def new
    @list = List.new
  end

  def edit
    set_list
  end

  def create
    @list = List.create(list_params)
    redirect_to "/lists/#{@list.id}"
  end

  def update
    set_list
    @list.update(list_params)
    redirect_to "/lists/#{@list.id}"
  end

  def destroy
    set_list
    List.destroy(@list.id)
    redirect_to "/lists/"
  end

  def test_view
  end

  def test_layout
    render layout: "missing"
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params["list"]
  end
end
