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
  # @param opts [Hash]
  # @option opts [Float] :aspect_ratio
  # @option opts [Array] :set_select array [ x, y, x2, y2 ] 
  # @option opts [Array] :min_size array [ w, h ]
  # @option opts [Array] :max_size array [ w, h ]
  # @option opts [String] :bg_color css value
  # @option opts [Float] :bg_opacity decimal 0 - 1 
  # @option opts [Boolean] :allow_resize (true) 
  # @option opts [Boolean] :allow_select (true) 
  def parse_jcrop_opts(opts)
    parsed = {}

    parsed[:aspect_ratio] = opts.fetch :aspect_ratio, @model.send("#{@attachment_name}_aspect")
    parsed[:set_select]   = opts.fetch :set_select,   [0, 0, (original_width / 2), (original_height / 2)]
    parsed[:min_size]     = opts.fetch :min_size,     [0, 0]
    parsed[:max_size]     = opts.fetch :max_size,     [0, 0]
    parsed[:bg_color]     = opts.fetch :bg_color,     'black'
    parsed[:bg_opacity]   = opts.fetch :bg_opacity,   0.6
    parsed[:allow_resize] = opts.fetch :allow_resize, true
    parsed[:allow_select] = opts.fetch :allow_select, true
  
    parsed
  end
end