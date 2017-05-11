# Class that encapsulates the logic from the cropbox options and geometries
#  
class Papercrop::Cropbox

  # Initializer
  # @param model
  # @param attachment_name [Symbol]
  def initialize(model, attachment_name)
    @attachment_name = attachment_name.to_sym
    @model           = model
    @attachment      = @model.send(@attachment_name)

    set_geometry
  end


  # Determines the attachment's presence and its geometry
  def image_is_present?
    @attachment.kind_of?(Paperclip::Attachment) && geometry?
  end


  # Stores the image geometry from the original attachment
  def set_geometry
    if @attachment.present?
      @geometry = @model.image_geometry(@attachment_name, :original) 
    end
  end


  # Responds if the geometry is present
  def geometry?
    @geometry.present?
  end


  # Returns the width of the original attachment
  def original_width
    @geometry.width.to_i
  end


  # Returns the height of the original attachment
  def original_height
    @geometry.height.to_i
  end


  # Parses and sets defaults for the extra Jcrop options
  # @see http://deepliquid.com/content/Jcrop_Manual.html for more info
  # @param opts [Hash] Options for jcrop, :width and :aspect are aliases for :box_width and :aspect_ratio
  # This is because retro compatibility with older versions.
  def parse_jcrop_opts(opts)
    parsed = opts.clone

    parsed[:box_width]    = parsed[:width]  if parsed[:box_width].nil?
    parsed[:aspect_ratio] = parsed[:aspect] if parsed[:aspect_ratio].nil?
    parsed.delete(:width)
    parsed.delete(:aspect)

    parsed[:box_width]    = original_width                            if parsed[:box_width].nil?
    parsed[:aspect_ratio] = @model.send("#{@attachment_name}_aspect") if parsed[:aspect_ratio].nil?
    parsed[:set_select]   = parsed.fetch :set_select, [0, 0, (original_width / 2), (original_height / 2)]
    parsed[:true_size] = [original_width, original_height]

    parsed
  end
end
