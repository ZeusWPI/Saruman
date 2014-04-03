class ItemsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :js

  def index
    @items = Item.includes(:reservations)
    authorize! :read, Item
  end

  def show
    @item = Item.find params.require(:id)
    authorize! :read, @item
  end

  def create
    authorize! :create, Item

    @item = Item.create item_params

    respond_with @item
  end

  def edit
    @item = Item.find params.require(:id)
    authorize! :update, @item

    respond_with @item
  end

  def update
    @item = Item.find params.require(:id)
    authorize! :update, @item

    @item.update item_params

    respond_with @item
  end

  def destroy
    @item = Item.find params.require(:id)
    authorize! :destroy, @item

    unless @item.reservations.any?
      @item.destroy
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :price, :quantity)
  end
end
