## Improved Papercrop
### Added Features:
1. Ability to set minimum and maximum crop size by defining `min_size` and `max_size` respectively in your model. e.g

        class User < ActiveRecord::Base
    
        has_attached_file :avatar, styles:{standard: "300x300",thumbnail:"100x100"}
        crop_attached_file :avatar , min_size:'300x300'
    
    Generally, you'll be setting min_size to your largest paperclip preset. In our example it is `300x300`. You may   want set max_size in similar way.

1. The initial crop selection size is set to the maximum width possible, a behaviour seen on Facebook.com.The implication of this subtle change is a noticeable improvement in user experience.

1. Now you do not have to set attr_accessible for papercrop parameters in your model. Previously, I had to add:

         attr_accessible :avatar_original_w, :avatar_original_h, :avatar_box_w, :avatar_crop_x,
         :avatar_crop_y, :avatar_crop_w, :avatar_crop_h, :avatar_aspect

   provided that the attachment name is `avatar`.

1. Includes minified resources. Saves an additional ~30kB.

For full documentation, visit the [original repository](https://github.com/rsantamaria/papercrop).
### Installation
Include this in your gemfile

    gem "papercrop", git: "https://github.com/ezuhaib/papercrop"
