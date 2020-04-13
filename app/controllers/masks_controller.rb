class MasksController < ApplicationController
  def index
    @tiger   = Mask.find_by(id: 1)
    @lion    = Mask.find_by(id: 2)
    @cheetah = Mask.find_by(id: 3)
    @cat     = Mask.find_by(id: 4)
  end

  def show
    @tiger   = Mask.find_by(id: 1)
    @lion    = Mask.find_by(id: 2)
    @cheetah = Mask.find_by(id: 3)
    @cat     = Mask.find_by(id: 4)
    @mask = Mask.find(params[:id])
  end
end
