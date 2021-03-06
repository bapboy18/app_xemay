class ReviewsController < ApplicationController
  before_action :reviews, :top_ten_rate, only: :index
  before_action :find_review, only: :show

  def search
    index
    render :index
  end

  def index
    @reviews = @q.result.eager_load(:store).to_a.uniq.reverse
    @stores = @reviews.map(&:store)
  end

  def show
    @user = @review.user
    @store = @review.store
    @products = @store.products
    @images = @store.images
    @comment = @review.comments.build
    @lat = @store.coordinate_lat
    @lng = @store.coordinate_lng

    @average_rating = @store.average("quality") ? @store.average("quality").avg : 0
    @total_rater = @store.rates("quality") ? @store.rates("quality").count : 0

    @store.avg_rating = @average_rating
    @store.total_rater = @total_rater
    @store.save
  end

  private
  def reviews
    @reviews = Review.all
  end

  def find_review
    @review = Review.find params[:id]
  end
end
