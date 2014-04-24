class ScanController < ApplicationController

  before_action :authenticate_user!

  respond_to :html, :js

  def index
    authorize! :scan, :all
  end

  def scan
    authorize! :scan, :all
    render action: :index
  end

  private
  def in
  end

  def out
  end

end
