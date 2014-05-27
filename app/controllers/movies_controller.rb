class MoviesController < ApplicationController

  def initialize
        @all_ratings = Movie.all_ratings
        super
    end

  def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
  end

  def index
      redirect = false

      if params[:sort]
          @sorting = params[:sort]
      elsif session[:sort]
          @sorting = session[:sort]
          redirect = true
      end

      if params[:ratings]
          @ratings = params[:ratings]
      elsif session[:ratings]
          @ratings = session[:ratings]
          redirect = true
      else
          @all_ratings.each do |rat|
              (@ratings ||= { })[rat] = 1
          end
          redirect = true
      end

      if redirect
          redirect_to movies_path(:sort => @sorting, :ratings => @ratings)
      end

      Movie.find(:all, :order => @sorting ? @sorting : :id).each do |mv|
          if @ratings.keys.include? mv[:rating]
              (@movies ||= [ ]) << mv
          end
      end

      session[:sort]    = @sorting
      session[:ratings] = @ratings
  end

  def new
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

  private

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
