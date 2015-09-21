class LandscapesController < ApplicationController
  before_action :set_landscape, only: [:show, :edit, :update, :crop, :destroy]

  # GET /landscapes
  # GET /landscapes.json
  def index
    @landscapes = Landscape.all
  end


  # GET /landscapes/1
  # GET /landscapes/1.json
  def show
  end


  # GET /landscapes/new
  def new
    @landscape = Landscape.new
  end


  # GET /landscapes/1/edit
  def edit
  end


  # POST /landscapes
  # POST /landscapes.json
  def create
    @landscape = Landscape.new(landscape_params)

    respond_to do |format|
      if @landscape.save
        format.html { render 'crop' }
        format.json { render action: 'show', status: :created, location: @landscape }
      else
        format.html { render action: 'new' }
        format.json { render json: @landscape.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /landscapes/1
  # PATCH/PUT /landscapes/1.json
  def update
    respond_to do |format|
      if @landscape.update(landscape_params)
        format.html { redirect_to @landscape, notice: 'Landscape was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @landscape.errors, status: :unprocessable_entity }
      end
    end
  end


  def crop
  end


  # DELETE /landscapes/1
  # DELETE /landscapes/1.json
  def destroy
    @landscape.destroy
    respond_to do |format|
      format.html { redirect_to landscapes_url }
      format.json { head :no_content }
    end
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_landscape
      @landscape = Landscape.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def landscape_params
      params.require(:landscape).permit(:name, :picture, :picture_crop_x, :picture_crop_y, :picture_crop_w, :picture_crop_h)
    end
end
