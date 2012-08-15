
## Papercrop
An easy extension for Paperclip to crop your image uploads using jCrop.

### Installation
Include papercrop in your Gemfile or install it by hand

    gem install papercrop

You need to add the required files in your assets...

In your application.js

    //= require jquery
    //= require jquery.jcrop
    //= require papercrop

In your application.css

    *= require jquery.jcrop

### Using Papercrop
You are a few steps away to start cropping attachments. Let's start with the model, a user with avatar:

    has_attached_file :avatar, :styles => {:thumb => '50x50', :medium => '100x100'}
    crop_attached_file :avatar
    
By default, the crop area and the preview box will have an aspect ratio of 1:1. 
You can modify that by passing a new aspect.

    crop_attached_file :snapshot, :aspect => "16:9"
    
On the controller you can render a view after user creation, create a simple crop action, etc... whatever you like the most. Inside the form of a persisted user:

    <%= form_for @user do |f| %>
      <%= f.cropbox :avatar %>
      <%= f.crop_preview :avatar %>
      <%= f.submit 'Save' %>
    <% end %>
    
Both helpers accept a :width option to customize their dimensions. The preview box has width 100 by default but the cropbox is unlimited in size (takes the original image width), so setting the cropbox width is interesting to avoid layout breaks with huge images. 

    <%= form_for @user do |f| %>
      <%= f.cropbox :avatar, :width => 500 %>
      <%= f.crop_preview :avatar, :width => 150 %>
      <%= f.submit 'Save' %>
    <% end %>
    
Regardless of the width, the preview box and the cropping area will have the aspect ratio defined in the model (1:1 by default)

That's all!

#### Credits and resources
* [Thoughtbot's Paperclip](https://github.com/thoughtbot/paperclip/)
* [Deep Liquid's JCrop](http://deepliquid.com/content/Jcrop.html)
* And Ryan Bates' [Railscast#182](http://railscasts.com/episodes/182-cropping-images/), which has inspired this gem