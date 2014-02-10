class Landscape < ActiveRecord::Base

  has_attached_file  :picture, :styles => {:thumb => "40x30", :medium => "400x300"},
                               :path   => ":rails_root/public/assets/uploads/landscapes/:id_:style.:extension",
                               :url    => "/assets/uploads/landscapes/:id_:style.:extension"
  validates_attachment_content_type :picture, :content_type => /.*/
  crop_attached_file :picture, :aspect => "4:3"

end
