class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @history_hash = params
    
    
    @all_ratings = Movie.all_ratings
    @selected_ratings = []
    if params[:ratings]
      params[:ratings].keys.each{|x| @selected_ratings << x}
    else
      @selected_ratings = session[:selected_ratings] || []
    end 
    session[:selected_ratings] = @selected_ratings
    @filter_ratings = @selected_ratings
    @filter_ratings = @all_ratings if @filter_ratings == []

    if params[:sort]
      @sort_by = params[:sort]
    else
      @sort_by = session[:sort_by] || ''
    end
    session[:sort_by] = @sort_by

    @css_title = "hilite" if @sort_by == 'title'
    @css_release_date = "hilite" if @sort_by  == 'release_date'
    @movies = Movie.find(:all, :conditions => {:rating => @filter_ratings}, :order => @sort_by)
  end

  def _index
    @history_hash = params
#@history_hash = @history_hash.delete("action") #.delete("contoller")
    if params.empty? && !session[:movies_index].empty?
      redirect_to movies_path(session[:movies_index])
    elsif !params.empty?
      session[:movies_index] = params
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = []
    params[:ratings].keys.each{|x| @selected_ratings << x} if params[:ratings]
    @filter_ratings = @selected_ratings
    @filter_ratings = @all_ratings if @filter_ratings == []

    if params[:sort] == 'title'
      @movies = Movie.find(:all, :conditions => {:rating =>  @filter_ratings}, :order => 'title')
      @css_title = "hilite"
    elsif params[:sort] == 'release_date'
      @movies = Movie.find(:all, :conditions => {:rating =>  @filter_ratings}, :order => 'release_date')
      @css_release_date = "hilite"
    else
      @movies = Movie.find(:all, :conditions => {:rating => @filter_ratings})
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
