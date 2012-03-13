class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index    
    @sort = params[:sort]
    @ratings = params[:ratings]
    if @ratings.nil?
	ratings = Movie.ratings
    else
	ratings = @ratings.keys
    end
    @all_ratings = Movie.ratings.inject(Hash.new) do |all_ratings, rating|
	all_ratings[rating] = @ratings.nil? ? false : @ratings.has_key?(rating)
	all_ratings
    end
    if !@sort.nil?
      begin
        @movies = Movie.order("#{@sort} ASC").find_all_by_rating(ratings)
      rescue ActiveRecord::StatementInvalid
        flash[:warning] = "Movies cannot be sorted by #{@sort}."
        @movies = Movie.find_all_by_rating(ratings)
      end
    else
      @movies = Movie.find_all_by_rating(ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
