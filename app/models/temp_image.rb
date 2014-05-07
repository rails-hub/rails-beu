class TempImage < ActiveRecord::Base
#  require 'aws/s3'
#  include S3

  require 'imgkit'
  RMAGICK_BYPASS_VERSION_TEST = true
  require 'RMagick'
  # attr_accessible :title, :body
  attr_accessible :logo_image, :retail_image, :thing_image, :session_id, :deal_id, :back_img_color, :back_color, :final_image,
                  :front_image_container_css, :description_css, :item_image_container_css, :local_final_image,
                  :local_final_large_img, :final_large_img
  attr_accessor :back_img_color, :back_color
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  has_attached_file :logo_image, :styles => { :thumb => "100x100>" }, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"
  has_attached_file :retail_image, :styles => { :thumb => "100x100>" }, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"
  has_attached_file :thing_image, :styles => { :thumb => "100x100>" }, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml"
  has_attached_file :final_image, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml" #, :processors => [:cropper]
  has_attached_file :local_final_image
  has_attached_file :local_final_large_img, :styles => { :original => "900x900!" }
  has_attached_file :final_large_img, :styles => { :original => "900x900!" }
  
#  has_attached_file :logo_image, :styles => { :thumb => "100x100>" }
#  has_attached_file :retail_image, :styles => { :thumb => "100x100>" }
#  has_attached_file :thing_image, :styles => { :thumb => "100x100>" }
#  has_attached_file :final_image
#  has_attached_file :local_final_image
#  has_attached_file :local_final_large_img, :styles => { :original => "900x900!" }
#  has_attached_file :final_large_img, :styles => { :original => "900x900!" }



  validates_attachment_content_type :logo_image, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'
  validates_attachment_content_type :retail_image, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'
  validates_attachment_content_type :thing_image, :content_type => /^image\/(jpg|jpeg|pjpeg|png|x-png|gif)$/, :message => 'file type is not allowed (only jpeg/png/gif images)'



  def image_dimensions
    image_name = ''
    if retail_image.queued_for_write[:original].present?
      image_name = 'retail_image'
      image_obj = retail_image
    elsif thing_image.queued_for_write[:original].present?
      image_name = 'thing_image'
      image_obj = thing_image
    elsif logo_image.queued_for_write[:original].present?
      image_name = 'logo_image'
      image_obj = logo_image
    end
    
    if image_name.present?
      dimensions = Paperclip::Geometry.from_file(image_obj.queued_for_write[:original].path)
      if dimensions.width < 400 and dimensions.height < 400
        #errors.add(image_name.to_sym,'Image width or height must be at least 400px')
      end
    end
    
  end

  validate :image_dimensions, :unless => "errors.any?"
  
#  after_update :reprocess_avatar, :if => :cropping?

  def reprocess_final_image(image_type)
    original_image_path = "#{Rails.root}/public"+self.local_final_image.url(:original).split('?')[0]
    self.image_crop(original_image_path,image_type)
  end

  def reprocess_final_large_image(image_type)
    large_image_path = "#{Rails.root}/public"+self.local_final_large_img.url(:original).split('?')[0]
    self.image_crop(large_image_path, image_type)
  end

  def image_crop(image_file_path, image_type)
      thumb = Magick::Image.read(image_file_path).first
      thumb.format = "PNG"
    
   puts "............image_file_url =#{image_file_path}"
   case image_type
   when 'small'
     thumb.crop_resized!(300,300, Magick::NorthWestGravity)
     thumb.write(image_file_path)
     self.final_image = self.local_final_image
   when 'large'
     thumb.crop_resized!(790,900, Magick::NorthWestGravity)
     thumb.write(image_file_path)
     self.final_large_img = self.local_final_large_img
   end
   self.save
    
  end


  def self.delete_raw_temp_images
    puts '***************************************************'
    puts '---------Starting Raw Temp Images Deletion--------'
    puts '***************************************************'
    TempImage.where(['created_at<?',Time.zone.now-2.day]).each do |temp_img|
      puts "Going to Delete TempImage#==>#{temp_img.id}"
      temp_img.destroy

    end
    
        puts '***************************************************'
    puts '---------Ending Raw Temp Images Deletion--------'
    puts '***************************************************'
  end
end
