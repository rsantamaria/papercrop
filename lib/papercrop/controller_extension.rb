module Papercrop
  module ControllerExtension
    
    def self.included(klass)
      klass.extend ClassMethods
    end


    module ClassMethods

      def crop_image(field_name, opts)
        opts[:after] ||= [:create, :update]
        opts[:class] ||= self.class.name.gsub("Controller", "").singularize.constantize 
      end

    end


    module InstanceMethods
    end
  end
end


# if defined? ActionController::Base
#   ActionController::Base.class_eval do
#     include Papercrop::ControllerExtension
#   end
# end