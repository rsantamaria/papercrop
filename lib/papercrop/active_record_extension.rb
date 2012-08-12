module Papercrop
  module ActiveRecordExtension
  
    def self.included(base)
      base.extend ClassMethods
    end


    module ClassMethods

      # Initializes attachment cropping in your model
      #
      #   crop_attached_file :avatar
      #
      # You can also define an aspect ratio for the crop and preview box through opts[:aspect]
      #
      #   crop_attached_file :avatar, :aspect => "4:3"
      #
      # @param attachment_name [Symbol] The name of the desired attachment to crop
      # @param opts [Hash]
      def crop_attached_file(attachment_name, opts = {})
        [:crop_x, :crop_y, :crop_w, :crop_h, :original_w, :original_h, :box_w, :aspect].each do |a|
          attr_accessor :"#{attachment_name}_#{a}"
        end

        if opts[:aspect].kind_of?(String) && opts[:aspect] =~ /^(\d{1,2}):(\d{1,2})$/
          opts[:aspect] = Range.new *opts[:aspect].split(':').map(&:to_i)
        end

        unless opts[:aspect].kind_of?(Range)
          opts[:aspect] = 1..1
        end

        send :define_method, :"#{attachment_name}_aspect" do
          opts[:aspect].first.to_f / opts[:aspect].last.to_f
        end

        attachment_definitions[attachment_name][:processors] ||= []
        attachment_definitions[attachment_name][:processors] << :cropper

        after_update :"reprocess_to_crop_#{attachment_name}_attachment"
      end

    end


    module InstanceMethods

      # Asks if the attachment received a crop process
      def cropping?(attachment_name)
        !self.send(:"#{attachment_name}_crop_x").blank? &&
        !self.send(:"#{attachment_name}_crop_y").blank? &&
        !self.send(:"#{attachment_name}_crop_w").blank? &&
        !self.send(:"#{attachment_name}_crop_h").blank?
      end


      # Returns a Paperclip::Geometry object from a named attachment
      #
      # @param attachment_name [Symbol] 
      # @param style [Symbol] attachment style, :original by default
      # @return Paperclip::Geometry
      def image_geometry(attachment_name, style = :original)
        @geometry        ||= {}
        @geometry[style] ||= Paperclip::Geometry.from_file(self.send(attachment_name).path(style))
      end


      def method_missing(method, *args)
        if method.to_s =~ /(reprocess_to_crop_)(\S{1,})(_attachment)/
          reprocess_cropped_attachment(
            method.to_s.scan(/(reprocess_to_crop_)(\S{1,})(_attachment)/).flatten.second.to_sym
          )
        else
          super
        end
      end

      private

        # Reprocess the attachment after cropping
        def reprocess_cropped_attachment(attachment_name)
          self.send(attachment_name.to_sym).reprocess! if cropping? attachment_name
        end

    end
  end
end


if defined? ActiveRecord::Base
  ActiveRecord::Base.class_eval do
    include Papercrop::ActiveRecordExtension
    include Papercrop::ActiveRecordExtension::InstanceMethods
  end
end