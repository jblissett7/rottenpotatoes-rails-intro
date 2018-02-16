class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    path_changed = false
    
    @ratings_checked = Hash.new
    @all_ratings.each do |rating|
      @ratings_checked[rating] = "1"
    end
      
      puts params[:ratings]
    if !params[:ratings].nil?
      session[:current_ratings] = params[:ratings]
      @movies = Movie.where(:rating => params[:ratings].keys())
      @ratings_checked = params[:ratings]
    elsif !session[:current_ratings].nil?
       @movies = Movie.where(:rating => session[:current_ratings].keys())
       @ratings_checked = session[:current_ratings]
       path_changed = true
    end
      
    if !params[:sort_by].nil?
      # Sort by the sort_by parameter
      session[:current_sort] = params[:sort_by]
      @movies = @movies.order(params[:sort_by])
    elsif !session[:current_sort].nil?
      @movies = @movies.order(session[:current_sort])
      params[:sort_by] = session[:current_sort]
      path_changed = true
    else
      @movies = @movies.all
    end
    
    if path_changed
      redirect_to(movies_path(:ratings => session[:current_ratings], :sort_by => session[:current_sort]))
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
