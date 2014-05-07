class Admin::ClassifiedCategoriesController < ApplicationController
  # GET /admin/classified_categories
  # GET /admin/classified_categories.json
  def index
    @admin_classified_categories = Admin::ClassifiedCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_classified_categories }
    end
  end

  # GET /admin/classified_categories/1
  # GET /admin/classified_categories/1.json
  def show
    @admin_classified_category = Admin::ClassifiedCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_classified_category }
    end
  end

  # GET /admin/classified_categories/new
  # GET /admin/classified_categories/new.json
  def new
    @admin_classified_category = Admin::ClassifiedCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_classified_category }
    end
  end

  # GET /admin/classified_categories/1/edit
  def edit
    @admin_classified_category = Admin::ClassifiedCategory.find(params[:id])
  end

  # POST /admin/classified_categories
  # POST /admin/classified_categories.json
  def create
    @admin_classified_category = Admin::ClassifiedCategory.new(params[:admin_classified_category])

    respond_to do |format|
      if @admin_classified_category.save
        format.html { redirect_to @admin_classified_category, notice: 'Classified category was successfully created.' }
        format.json { render json: @admin_classified_category, status: :created, location: @admin_classified_category }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_classified_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/classified_categories/1
  # PUT /admin/classified_categories/1.json
  def update
    @admin_classified_category = Admin::ClassifiedCategory.find(params[:id])

    respond_to do |format|
      if @admin_classified_category.update_attributes(params[:admin_classified_category])
        format.html { redirect_to @admin_classified_category, notice: 'Classified category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_classified_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/classified_categories/1
  # DELETE /admin/classified_categories/1.json
  def destroy
    @admin_classified_category = Admin::ClassifiedCategory.find(params[:id])
    @admin_classified_category.destroy

    respond_to do |format|
      format.html { redirect_to admin_classified_categories_url }
      format.json { head :no_content }
    end
  end
end
