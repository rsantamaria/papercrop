module Papercrop
  module ModelExtension

    module ClassMethods

      # Initializes attachment cropping in your model
      #
      #   crop_attached_file :avatar
      #
      # You can also define an aspect ratio for the crop and preview box through opts[:aspect]
      #
      #   crop_attached_file :avatar, :aspect => "4:3"
      #
      # @param attachment_name [Symbol] Name of the desired attachment to crop
      # @param opts [Hash]
      def crop_attached_file(attachment_name, opts = {})
        [:crop_x, :crop_y, :crop_w, :crop_h, :original_w, :original_h, :box_w, :aspect, :cropped_geometries].each do |a|
          attr_accessor :"#{attachment_name}_#{a}"
        end

        if opts[:aspect].kind_of?(String) && opts[:aspect] =~ Papercrop::RegExp::ASPECT
          opts[:aspect] = Range.new *opts[:aspect].split(':').map(&:to_i)
        end

        unless opts[:aspect].kind_of?(Range)
          opts[:aspect] = 1..1
        end

        send :define_method, :"#{attachment_name}_aspect" do
          opts[:aspect].first.to_f / opts[:aspect].last.to_f
        end

        if respond_to? :attachment_definitions
          # for Paperclip <= 3.4 
          definitions = attachment_definitions
        else
          # for Paperclip >= 3.5
          definitions = Paperclip::Tasks::Attachments.instance.definitions_for(self)
        end

        definitions[attachment_name][:processors] ||= []
        definitions[attachment_name][:processors] << :cropper

        after_update :"reprocess_to_crop_#{attachment_name}_attachment"
      end
    end


    module InstanceMethods

      # Asks if the attachment received a crop process
      # @param  attachment_name [Symbol]
      # 
      # @return [Boolean]
      def cropping?(attachment_name)
        !self.send(:"#{attachment_name}_crop_x").blank? &&
        !self.send(:"#{attachment_name}_crop_y").blank? &&
        !self.send(:"#{attachment_name}_crop_w").blank? &&
        !self.send(:"#{attachment_name}_crop_h").blank?
      end


      # Returns a Paperclip::Geometry object of a given attachment
      #
      # @param attachment_name [Symbol]
      # @param style = :original [Symbol] attachment style
      # @return [Paperclip::Geometry]
      def image_geometry(attachment_name, style = :original)
        @geometry ||= {}
        path = ([:s3, :fog].include? self.send(attachment_name).options[:storage]) ? self.send(attachment_name).url(style) : self.send(attachment_name).path(style)
        @geometry[style] ||= Paperclip::Geometry.from_file(path)
      end


      # Uses method missing to responding the model callback
      def method_missing(method, *args)
        if method.to_s =~ Papercrop::RegExp::CALLBACK
          reprocess_cropped_attachment(
            method.to_s.scan(Papercrop::RegExp::CALLBACK).flatten.first.to_sym
          )
        else
          super
        end
      end


      # Sets all cropping attributes to nil
      # @param  attachment_name [Symbol]
      def reset_crop_attributes_of(attachment_name)
        [:crop_x, :crop_y, :crop_w, :crop_h].each do |a|
          self.send :"#{attachment_name}_#{a}=", nil
        end
      end

      private

        # Saves the attachment if the crop attributes are present
        # @param  attachment_name [Symbol]
        def reprocess_cropped_attachment(attachment_name)
          if cropping?(attachment_name)
            attachment_instance = send(attachment_name)
            attachment_instance.assign(attachment_instance)
            attachment_instance.save

            reset_crop_attributes_of(attachment_name)
          end
        end

    end
  end
end


# ActiveRecord support
if defined? ActiveRecord::Base
  ActiveRecord::Base.class_eval do
    extend  Papercrop::ModelExtension::ClassMethods
    include Papercrop::ModelExtension::InstanceMethods
  end
end


# Mongoid support
if defined? Mongoid::Document 
  Mongoid::Document::ClassMethods.module_eval do
    include Papercrop::ModelExtension::ClassMethods
  end

  Mongoid::Document.module_eval do
    include Papercrop::ModelExtension::InstanceMethods
  end
end
