class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /shows
  # GET /shows.json
  def index
    @test = params[:comedy]

    @shows = Show.show_name_search(params[:show_name_search])
             .individual_season_filter
             .remove_wikipedia_categories
             .network_search(params[:network_search])
             .min_imdb_rating(params[:min_imdb_rating])
             .max_imdb_rating(params[:max_imdb_rating])
             .min_metacritic_rating(params[:min_metacritic_average_rating])
             .max_metacritic_rating(params[:max_metacritic_average_rating])
             .min_tv_dot_com_rating(params[:min_tv_dot_com_rating])
             .max_tv_dot_com_rating(params[:max_tv_dot_com_rating])
             .imdb_min_rating_count(params[:imdb_min_rating_count])
             .tv_dot_com_min_rating_count(params[:tv_dot_com_min_rating_count])
             .amazon_instant_filter(params[:amazon_instant])
             .amazon_own_filter(params[:amazon_own])
             .comedy_filter(params[:comedy])
             .drama_filter(params[:drama])
             .language_filter(params[:language])
             .serialized_only_filter(params[:serialized_only])
             .united_states_filter(params[:united_states])
             .united_kingdom_filter(params[:united_kingdom])
             .commonwealth_filter(params[:commonwealth])
             .min_seasons_filter(params[:min_seasons])
             .max_seasons_filter(params[:max_seasons])
             .min_episodes_filter(params[:min_episodes])
             .max_episodes_filter(params[:max_episodes])
             .order(sort_column + " " + sort_direction)
             .paginate(:per_page => 50, :page => params[:page])
  end

  #.min_imdb_rating(params[:min_imdb_rating])
  #.max_imdb_rating(params[:max_imdb_rating])

  def serialized
    @shows = Show.show_name_search(params[:show_name_search]).combo_filter(params[:drama], params[:comedy]).order(sort_column + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])
  end

  def drama_display
    @shows = Show.show_name_search(params[:show_name_search])
             .where("genre_1 LIKE ? OR genre_2 LIKE ? OR genre_3 LIKE ? OR genre_4 LIKE ? OR genre_5 LIKE ? OR format_1 LIKE ? OR format_2 LIKE ? OR format_3 LIKE ? OR format_4 LIKE ? OR format_5 LIKE ?", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%", "%drama%")
             .individual_season_filter
             .remove_wikipedia_categories
             .network_search(params[:network_search])
             .comedy_filter(params[:comedy])
             .drama_filter(params[:drama])
             .language_filter(params[:language])
             .serialized_only_filter(params[:serialized_only])
             .united_states_filter(params[:united_states])
             .united_kingdom_filter(params[:united_kingdom])
             .commonwealth_filter(params[:commonwealth])
             .min_seasons_filter(params[:min_seasons])
             .max_seasons_filter(params[:max_seasons])
             .min_episodes_filter(params[:min_episodes])
             .max_episodes_filter(params[:max_episodes])
             .order(sort_column + " " + sort_direction)
             .paginate(:per_page => 50, :page => params[:page])
  end

  def children
    @shows = Show.show_name_search(params[:show_name_search])
    .where("genre_1 LIKE ? OR genre_2 LIKE ? OR genre_3 LIKE ? OR genre_4 LIKE ? OR genre_5 LIKE ? OR format_1 LIKE ? OR format_2 LIKE ? OR format_3 LIKE ? OR format_4 LIKE ? OR format_5 LIKE ?", "%children%", "%children%", "%children%", "%children%", "%children%", "%children%", "%children%", "%children%", "%children%", "%children%")
    .individual_season_filter
    .remove_wikipedia_categories
    .network_search(params[:network_search])
    .comedy_filter(params[:comedy])
    .drama_filter(params[:drama])
    .language_filter(params[:language])
    .serialized_only_filter(params[:serialized_only])
    .united_states_filter(params[:united_states])
    .united_kingdom_filter(params[:united_kingdom])
    .commonwealth_filter(params[:commonwealth])
    .min_seasons_filter(params[:min_seasons])
    .max_seasons_filter(params[:max_seasons])
    .min_episodes_filter(params[:min_episodes])
    .max_episodes_filter(params[:max_episodes])
    .order(sort_column + " " + sort_direction)
    .paginate(:per_page => 50, :page => params[:page])
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
