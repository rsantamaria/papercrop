require "paperclip"
require 'dimensions'

module Paperclip
  class Cropper < Thumbnail

    def transformation_command
      if crop_command
        crop_command + super.join(' ').sub(/ -crop \S+/, '').split(' ')
      else
        super
      end
    end


    def crop_command
      target = @attachment.instance
      
      if target.cropping?(@attachment.name)
        w = target.send :"#{@attachment.name}_crop_w"
        h = target.send :"#{@attachment.name}_crop_h"
        x = target.send :"#{@attachment.name}_crop_x"
        y = target.send :"#{@attachment.name}_crop_y"
        o_w = target.send :"#{@attachment.name}_original_w"
        o_h = target.send :"#{@attachment.name}_original_h"
        
        case (Dimensions.angle(@attachment.instance.photo.path))
        when 90
          tmp = x.to_i
          x = y
          y = o_w.to_i - w.to_i - tmp.to_i
        end
        
        ["-crop", "#{w}x#{h}+#{x}+#{y}"]
      end
    end

  end
end