class LandscapesController < ApplicationController
  
  # GET /landscapes
  # GET /landscapes.json
  def index
    @landscapes = Landscape.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @landscapes }
    end
  end


  # GET /landscapes/1
  # GET /landscapes/1.json
  def show
    @landscape = Landscape.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @landscape }
    end
  end


  # GET /landscapes/new
  # GET /landscapes/new.json
  def new
    @landscape = Landscape.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @landscape }
    end
  end


  # GET /landscapes/1/edit
  def edit
    @landscape = Landscape.find(params[:id])
  end


  # POST /landscapes
  # POST /landscapes.json
  def create
    @landscape = Landscape.new(landscape_params)

    respond_to do |format|
      if @landscape.save
        format.html { render 'crop' }
        format.json { render json: @landscape, status: :created, location: @landscape }
      else
        format.html { render action: "new" }
        format.json { render json: @landscape.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /landscapes/1
  # PUT /landscapes/1.json
  def update
    @landscape = Landscape.find(params[:id])

    respond_to do |format|
      if @landscape.update_attributes(landscape_params)
        format.html { redirect_to @landscape, notice: 'Landscape was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @landscape.errors, status: :unprocessable_entity }
      end
    end
  end


  # POST /landscapes/1/crop
  # POST /landscapes/1/crop.json
  def crop
    @landscape = Landscape.find(params[:id])
  end


  # DELETE /landscapes/1
  # DELETE /landscapes/1.json
  def destroy
    @landscape = Landscape.find(params[:id])
    @landscape.destroy

    respond_to do |format|
      format.html { redirect_to landscapes_url }
      format.json { head :no_content }
    end
  end

private

  def landscape_params
    params.fetch(:landscape, {}).permit!
  end

end
