class ItemsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @items = Item.all
  end

  def barcodes
    @barcodes = Item.all
    render 'barcodes/barcodes'
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new item_params

    if @item.save
      redirect_to items_path
    else
      render :new
    end
  end

  def edit
    respond_with @item
  end

  def update
    @item.update item_params
    respond_with @item
  end

  def destroy
    @item.destroy unless @item.reservations.any?
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :category_id, :price, :quantity)
  end
end
