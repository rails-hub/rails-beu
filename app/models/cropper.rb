module Paperclip
  class Cropper < Thumbnail
#    def initialize(file, options = {}, attachment = nil)
#      super
#      @current_geometry.width  = target.crop_width
#      @current_geometry.height = target.crop_height
#    end
    
#    def target
#      @attachment.instance
#    end
#    def transformation_command
#      crop_command = [
#        "-crop",
#        "#{target.crop_width}x" \
#          "#{target.crop_height}+" \
#          "#{target.crop_x}+" \
#          "#{target.crop_y}",
#        "+repage"
#      ]
#      crop_command + super
#    end
 



  # ///////////////////////////////

  def transformation_command
      if crop_command
        crop_command + super.sub(/ -crop \S+/, '')
      else
        super
      end
    end

    def crop_command
      target = @attachment.instance
      if target.cropping?
        " -crop '#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}'"
      end
    end

  end
end