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
    # You can override the aspect ratio used by Jcrop, and even unlock it by setting :aspect to a new value or false
    #
    #   cropbox :avatar, :width => 650, :aspect => false
    #
    # @param attachment [Symbol] attachment name
    # @param opts [Hash]
    def cropbox(attachment, opts = {})
      attachment      = attachment.to_sym
      original_width  = self.object.image_geometry(attachment, :original).width.to_i
      original_height = self.object.image_geometry(attachment, :original).height.to_i
      box_width       = opts.fetch :width,  original_width
      aspect          = opts.fetch :aspect, self.object.send(:"#{attachment}_aspect")
      crop_x          = opts.fetch :crop_x, 0
      crop_y          = opts.fetch :crop_y, 0
      crop_w, crop_h  = calculate_dimensions(opts, crop_x, crop_y, original_width, original_height, aspect)

      if self.object.send(attachment).class == Paperclip::Attachment
        box  = self.hidden_field(:"#{attachment}_original_w", :value => original_width)
        box << self.hidden_field(:"#{attachment}_original_h", :value => original_height)
        box << self.hidden_field(:"#{attachment}_box_w",      :value => box_width)
        box << self.hidden_field(:"#{attachment}_aspect",     :value => aspect, :id => "#{attachment}_aspect")
        box << self.hidden_field(:"#{attachment}_initial_crop_x", :value => crop_x, :id => "#{attachment}_initial_crop_x")
        box << self.hidden_field(:"#{attachment}_initial_crop_y", :value => crop_y, :id => "#{attachment}_initial_crop_y")
        box << self.hidden_field(:"#{attachment}_initial_crop_w", :value => crop_w, :id => "#{attachment}_initial_crop_w")
        box << self.hidden_field(:"#{attachment}_initial_crop_h", :value => crop_h, :id => "#{attachment}_initial_crop_h")

        for attribute in [:crop_x, :crop_y, :crop_w, :crop_h] do
          box << self.hidden_field(:"#{attachment}_#{attribute}", :id => "#{attachment}_#{attribute}")
        end

        crop_image = @template.image_tag(self.object.send(attachment).url)

        box << @template.content_tag(:div, crop_image, :id => "#{attachment}_cropbox")
      end
    end

    #
    # calculates the width and height of the cropped image.
    #
    def calculate_dimensions(opts, crop_x, crop_y, original_width, original_height, aspect)
      remaining_width = original_width - crop_x
      remaining_height= original_height - crop_x
      if aspect
        if remaining_width / aspect < remaining_height
          return [
            opts.fetch(:crop_w, crop_x + remaining_width),
            opts.fetch(:crop_h, crop_y + remaining_width / aspect)
          ]
        else
          return [
            opts.fetch(:crop_w, crop_x + remaining_height * aspect),
            opts.fetch(:crop_h, crop_y + remaining_height)
          ]
        end
      else
        return [
          opts.fetch(:crop_w, original_width),
          opts.fetch(:crop_h, original_height)
        ]
      end
    end
  end
end


if defined? ActionView::Helpers::FormBuilder
  ActionView::Helpers::FormBuilder.class_eval do
    include Papercrop::Helpers
  end
end
