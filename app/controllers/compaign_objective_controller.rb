class CompaignObjectiveController < ApplicationController

  def index
     @compaign_objectives = CompaignObjective.all
  end

  def new
     @compaign_objectives = CompaignObjective.new
  end
  
  def create
     @compaign_objectives = CompaignObjective.new(params[:compaign_objective])
  end

  def edit
     @compaign_objectives = CompaignObjective.find(params[:id])
  end
  
  def update
     @compaign_objectives = CompaignObjective.new(params[:compaign_objective])
  end

  def show
    @compaign_objectives = CompaignObjective.find(params[:id])
  end

end
