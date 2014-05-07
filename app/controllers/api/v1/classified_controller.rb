class Api::V1::ClassifiedController < Api::V1::BaseController
before_filter :validateTokenKey
  def get_classifieds
    if params[:category_id].present?
       @classifieds = Admin::Classified.includes(:classified_category).where(:classified_category_id => params[:category_id])
        classified_arr=[]
        count =0
        @classifieds.each do |classified|
          category_name = classified.classified_category.present? ? classified.classified_category.name : ''
          classified_arr << {:id => classified.id, :name => classified.name, :category_name => category_name}
          count =count+1
        end
    else
      message = 'Required Parameter(s) Missing'
    end
   
    

     respond_to do |format|
      if params[:category_id].blank? or classified_arr.blank?
        message = message.present? ? message : "No Classified found"
        format.json {render json:{:success => false, :status_code => 400, :message => message}}
        format.xml {render xml:{:success => false, :status_code => 400, :message => message}}
        format.html {render json: {:success => false, :status_code => 400, :message => message}}
      else
        format.html {render json: {:success => true, :status_code => 200, :classifieds => classified_arr}}
        format.json {render json: {:success => true, :status_code => 200, :classifieds => classified_arr}}
        format.xml {render xml: {:success => true, :status_code => 200, :classifieds => classified_arr}}
      end
    end
  end

end
