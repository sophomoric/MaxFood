class RecipeIngredientsController < ApplicationController
  def create
    
    @recipe = Recipe.find(params[:recipe_id])
    
    #must change name to an ingredient_id (or create the ingredient first)
    @ingredient = Ingredient.find_by_name(params[:recipe_ingredient][:name])
    if !@ingredient
      @ingredient = Ingredient.create({name: params[:recipe_ingredient][:name]})
      @ingredient.save
    end
    
    recipe_ingredient_hash = {ingredient_id: @ingredient.id}.merge(recipe_ingredient_params)
    recipe_ingredient_hash.delete("name")
    
    @recipe_ingredient = @recipe.recipe_ingredients.new(recipe_ingredient_hash)
    
    
    
    #maybe you want to take them to a new page to fill out the allergt info for the new ingredient

      
    if @recipe_ingredient.save
      redirect_to :back
    else
      
      redirect_to :back
    end   
    
    
    # redirect_to recipe_ingredient_path(@recipe_ingredient)
  end
  #passing @recipe_ingredient to the show viwe
  def update
    recipe = Recipe.find(params[:recipe_id])
    @recipe_ingredient = recipe.recipe_ingredients.find(params[:id])
    if @recipe_ingredient.update_attributes(recipe_ingredient_params)
      flash.now[:messages] = ["successful update"]
    else
      flash.now[:errors] = @recipe_ingredient.errors.full_messages
    end
    redirect_to :back
  end
  
  def destroy
    recipe_ingredient = RecipeIngredient.find(params[:id])
    if recipe_ingredient.destroy
      
    else
      flash.now[:errors] = ["could not delete this recipe ingredient"]
    end
    redirect_to :back
  end


  private
  # a recipe ingredient has an amount and a unit
  def recipe_ingredient_params
    params.require(:recipe_ingredient).permit(:name, :unit, :amount)
  end

end
