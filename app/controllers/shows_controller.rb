class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /shows
  # GET /shows.json
  def index
    @shows = Show.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])
  end

  def serialized
    @shows = Show.where(:serialized => true).search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])
  end

  def drama
    @shows = Show.where('genre_1 like ?', '%drama%').search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])
  end

  def children
    @shows = Show.where('genre_1 like ?', '%children%').search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])
  end

  def test_page
    @wikipediaapiquery = WikipediaApiQuery.all
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
  end

  # GET /shows/new
  def new
    @show = Show.new
  end

  # GET /shows/1/edit
  def edit
  end

  # POST /shows
  # POST /shows.json
  def create
    @show = Show.new(show_params)

    respond_to do |format|
      if @show.save
        format.html { redirect_to @show, notice: 'Show was successfully created.' }
        format.json { render action: 'show', status: :created, location: @show }
      else
        format.html { render action: 'new' }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shows/1
  # PATCH/PUT /shows/1.json
  def update
    respond_to do |format|
      if @show.update(show_params)
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show.destroy
    respond_to do |format|
      format.html { redirect_to shows_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_params
      params[:show]
    end

    # This method is set up to provide a default to the column sorting if the params hash is empty. From railscast 228.
    def sort_column
      Show.column_names.include?(params[:sort]) ? params[:sort] : "last_aired"
    end

    # This method is set up to provide a default to the column sorting if the params hash is empty. From railscast 228.
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end