class ItemsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  respond_to :html, :js

  def index
    @items = @items.includes(:reservations)
  end

  def show
  end

  def create
    @item.save
    respond_with @item
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
    params.require(:item).permit(:name, :description, :category, :price, :deposit, :quantity)
  end
end
