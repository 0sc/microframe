class ItemsController < Microframe::ApplicationController
  def index
    redirect_to("/lists/#{params[:list_id]}")
  end

  def show
    set_item
  end

  def new
    set_list
    @item = Item.new
  end

  def edit
    set_item
  end

  def create
    set_list
    @item = Item.create(item_params)
    redirect_to("/lists/#{@list.id}/items/#{@item.id}")
  end

  def update
    set_item
    @item.update(item_params)
    redirect_to("/lists/#{@list.id}/items/#{@item.id}")
  end

  def destroy
    set_item
    Item.destroy(@item.id)
    redirect_to("/lists/#{params[:list_id]}")
  end

  def queries
    set_item
    if @list || params[:list_id].to_i > 0
      @item = List.first.items.all
    else
      redirect_to "/lists"
    end
  end

  private

  def set_list
    @list = List.find_by(id: params[:list_id])
  end

  def set_item
    set_list
    @item = @list.items.find_by(id: params[:id]).load if @list
  end

  def item_params
    params["item"].merge!("list_id" => @list.id)
    params["item"].merge!("done" => "false") unless params["item"]["done"]
    params["item"]
  end
end
