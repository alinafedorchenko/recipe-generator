class RecipesController < ApplicationController
  def index
  end

  def create
    ingredients = recipe_params[:ingredients]
    source = :anthropic

    service = RecipeGeneratorService.new(ingredients, source:)
    @result = service.call

    if @result[:error]
      redirect_to recipes_path, notice: @result[:error]
    else
      flash[:notice] = nil
      respond_to(&:turbo_stream)
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:ingredients)
  end
end
