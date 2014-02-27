## Improved Papercrop
This fork adds ability to set minimum and maximum crop size by defining `min_size` and `max_size` respectively in your model. e.g

    class User < ActiveRecord::Base
    
    has_attached_file :avatar, styles:{standard: "300x300",thumbnail:"100x100"}
    crop_attached_file :avatar , min_size:'300x300'
    
Generally, you'll be setting min_size to your largest paperclip preset. In our example it is `300x300`. You may want set max_size in similar way.

This fork also sets the initial crop selection size to the maximum width possible, a behaviour seen on Facebook.com.
    
For full documentation, visit the [original repository](https://github.com/rsantamaria/papercrop).
### Installation
Include this in your gemfile

    gem "papercrop", git: "https://github.com/ezuhaib/papercrop"
