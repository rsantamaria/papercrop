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

        image_options = {
          :id    => "#{attachment}_crop_preview",
          :style => "max-width:none; max-height:none"
        }

        preview_image = @template.image_tag(self.object.send(attachment).url, image_options)

        @template.content_tag(:div, preview_image, wrapper_options)
      end
    end


    # Form helper to render the main cropping box of an attachment.
    # Loads the original image. Initially the cropbox has no limits on dimensions, showing the image at full size.
    # You can restrict it by setting the :width option to the width you want.
    #
    #   cropbox :avatar, :width => 650
    # 
    # Also, you can use some of the options jcrop has in its api for extra customization.
    # @see http://deepliquid.com/content/Jcrop_Manual.html 
    #
    #   cropbox :avatar, :width => 650, :jcrop => {:aspect_ratio => 1, :set_select => [0, 0, 500, 500]}
    #
    # Keep in mind that calling the cropbox with an empty attachment will result into an empty div
    # 
    # @param attachment [Symbol] attachment name
    # @param opts [Hash]
    # @option opts [Integer] :width 
    # @option opts [Hash] :jcrop Jcrop extra options. See Papercrop::Cropbox for more info
    def cropbox(attachment, opts = {})
      cropbox = Papercrop::Cropbox.new(object, attachment)

      if cropbox.image_is_present?
        box_width = opts.fetch :width, cropbox.original_width

        box  = hidden_field(:"#{attachment}_original_w", :value => cropbox.original_width)
        box << hidden_field(:"#{attachment}_original_h", :value => cropbox.original_height)
        box << hidden_field(:"#{attachment}_box_w",      :value => box_width)

        for attribute in [:crop_x, :crop_y, :crop_w, :crop_h] do
          box << hidden_field(:"#{attachment}_#{attribute}", :id => "#{attachment}_#{attribute}")
        end

        crop_image = @template.image_tag(self.object.send(attachment).url)
        jcrop_opts = cropbox.parse_jcrop_opts(opts[:jcrop] || {})

        box << @template.content_tag(:div, crop_image, :id => "#{attachment}_cropbox", :data => jcrop_opts)
      else
        @template.content_tag(:div, "", :id => "#{attachment}_cropbox_blank")
      end
    end
  end
end


if defined? ActionView::Helpers::FormBuilder
  ActionView::Helpers::FormBuilder.class_eval do
    include Papercrop::Helpers
  end
end
