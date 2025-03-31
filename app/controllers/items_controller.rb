class ItemsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  respond_to :html, :js

  def index
    @items = @items.includes(:reservations)
  end

  def create
    @item.save

    if @item.save
      flash.now[:success] = "Item #{@item.name} created!"
    else
      @show_validations = true
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    respond_with @item
  end

  def update
    if @item.update(item_params)
      flash.now[:success] = "Item #{@item.name} updated!"
    else
      @show_validations = true
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy unless @item.reservations.any?

    flash.now[:success] = "Item #{@item.name} is removed!"
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :category, :price, :deposit, :quantity)
  end
end
