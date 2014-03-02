module Papercrop
  module Helpers
    
    # Form helper to render the cropping preview box of an attachment.
    # Box width can be handled by setting the :width option. 
    # Width is 100 by default. Height is calculated by the aspect ratio.
    # 
    #   crop_preview :avatar
    #   crop_preview :avatar, :width => 150
    #
    # @param attachment [Symbol] attachment name
    # @param opts [Hash]
    def crop_preview(attachment, opts = {})
      attachment = attachment.to_sym
      width      = opts[:width] || 100
      height     = (width / self.object.send(:"#{attachment}_aspect")).round 

      if self.object.send(attachment).class == Paperclip::Attachment
        wrapper_options = {
          :id    => "#{attachment}_crop_preview_wrapper",
          :style => "width:#{width}px; height:#{height}px; overflow:hidden"
        }

        preview_image = @template.image_tag(self.object.send(attachment).url, :id => "#{attachment}_crop_preview")

        @template.content_tag(:div, preview_image, wrapper_options)
      end
    end


    # Form helper to render the main cropping box of an attachment.
    # Loads the original image. Initially the cropbox has no limits on dimensions, showing the image at full size.
    # You can restrict it by setting the :width option to the width you want.
    #
    #   cropbox :avatar, :width => 650
    #
    # @param attachment [Symbol] attachment name
    # @param opts [Hash]
    def cropbox(attachment, opts = {})
      attachment      = attachment.to_sym
      original_width  = self.object.image_geometry(attachment, :original).width
      original_height = self.object.image_geometry(attachment, :original).height
      box_width       = opts[:width] || original_width

      if self.object.send(attachment).class == Paperclip::Attachment
        box  = self.hidden_field(:"#{attachment}_original_w", :value => original_width)
        box << self.hidden_field(:"#{attachment}_original_h", :value => original_height)
        box << self.hidden_field(:"#{attachment}_box_w",      :value => box_width)

        for attribute in [:crop_x, :crop_y, :crop_w, :crop_h, :aspect, :min_size, :max_size] do
          box << self.hidden_field(:"#{attachment}_#{attribute}", :id => "#{attachment}_#{attribute}")
        end

        crop_image = @template.image_tag(self.object.send(attachment).url)

        box << @template.content_tag(:div, crop_image, :id => "#{attachment}_cropbox")
      end
    end
  end
end


if defined? ActionView::Helpers::FormBuilder
  ActionView::Helpers::FormBuilder.class_eval do
    include Papercrop::Helpers
  end
end