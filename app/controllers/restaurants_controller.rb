class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def create
    restaurant = Restaurant.find(params[:id])
    review = Review.create(review_params)
    review.user = current_user
    review.restaurant = restaurant
    review.save
    redirect_to restaurant_path(restaurant)
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

end
