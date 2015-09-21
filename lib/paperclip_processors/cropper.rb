require "paperclip"

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
        
        if @attachment.instance.photo_orientation.present?
          case (@attachment.instance.photo_orientation)
          when 3
            x = o_w.to_i - w.to_i - x.to_i
            y = o_h.to_i - h.to_i - y.to_i
          when 6
            tmp = x.to_i
            x = y
            y = o_w.to_i - w.to_i - tmp
          when 8
            tmp = x.to_i
            x = o_h.to_i - h.to_i - y.to_i
            y = tmp
          end
        end
        
        ["-crop", "#{w}x#{h}+#{x}+#{y}"]
      end
    end

  end
end