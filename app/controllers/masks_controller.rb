class MasksController < ApplicationController
  before_action :set_header, only: [:index, :show, :about_us]

  def index
  end

  def show
    @mask = Mask.find(params[:id])
  end

  def about_us
  end

  private
    def set_header
      @tiger   = Mask.find_by(id: 1)
      @lion    = Mask.find_by(id: 2)
      @cheetah = Mask.find_by(id: 3)
      @cat     = Mask.find_by(id: 4)
    end
end
