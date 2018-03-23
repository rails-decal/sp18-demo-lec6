class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def create_review
    restaurant = Restaurant.find(params[:id])
    review = Review.create(review_params)
    review.user = current_user
    review.restaurant = restaurant
    if review.save
      redirect_to restaurant_path(restaurant)
    else
      flash[:error] = review.errors.full_messages.to_sentence
      redirect_to restaurant_path(restaurant)
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

end
