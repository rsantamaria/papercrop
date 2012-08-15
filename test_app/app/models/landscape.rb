class Landscape < ActiveRecord::Base
  attr_protected

  has_attached_file  :picture, :styles => {:thumb => "40x30", :medium => "400x300"},
                               :path   => ":rails_root/public/assets/uploads/landscapes/:id_:style.:extension",
                               :url    => "uploads/landscapes/:id_:style.:extension"
  crop_attached_file :picture, :aspect => "4:3"
end
