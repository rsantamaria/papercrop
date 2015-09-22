class User < ActiveRecord::Base

  has_attached_file  :avatar, :styles => {:thumb => "50x50#", :medium => "200x200#"},
                              :path   => ":rails_root/public/assets/uploads/users/:id_avatar_:style.:extension",
                              :url    => "/assets/uploads/users/:id_avatar_:style.:extension"

  has_attached_file  :signature, :styles => {:medium => "496x279#"},
                                 :path   => ":rails_root/public/assets/uploads/users/:id_signature_:style.:extension",
                                 :url    => "/assets/uploads/users/:id_signature_:style.:extension"

  validates_attachment_content_type :avatar, :content_type => /.*/
  
  crop_attached_file :avatar,    :aspect => 1..1
  crop_attached_file :signature, :aspect => 16..9
end