
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

If you're rendering it on ajax ensure to call init_papercrop() in js after loading the crop form to make things work properly.  

### Advanced features

**Unlock aspect ratio**

You can unlock the aspect ratio if you pass false as argument. NOTE: *preview will be disabled*

    crop_attached_file :snapshot, :aspect => false

Regardless the model, you can always redefine/unlock aspect from the helper if you need to.

    f.cropbox :snapshot, :width => 500, :aspect => 4..3

**Chaining processors**

Maybe you want to chain some custom processors to do amazing effects like crop+rotate images. Papercrop will add its processor in last place unless you declare it in the attachment definition

    has_attached_file :landscape, :styles => {:big => '2000x1500'}, 
                                  :processors => [:papercrop, :rotator]

### Running the Tests

We are using dummy applications to handle some of our test cases with different Gemfiles using [Appraisal](https://github.com/thoughtbot/appraisal). You can find them in the `/test_apps` directory and should be able to run them as a regular Rails app _(using the `rails s` command)_ if you're interested in taking a look. You may need to create mock databases for the `test_apps` before your tests will start to pass. This means you need to run the classics `rake db:create db:migrate db:test:prepare` through appraisal from the root directory.

    appraisal rails_3_2 rake db:create db:migrate
    appraisal rails_4 rake db:create db:migrate

Append RAILS_ENV=test to both commands to prepare each database for testing

In order to fully test our gem, we needed to use the [Poltergeist gem](https://github.com/teampoltergeist/poltergeist) and [PhantomJS](http://phantomjs.org/). Getting this setup is beyond the scope of this Readme.

Once you have everything setup, you should be able to execute `appraisal rake` from the root directory have everything run.

That's all!

### Credits and resources
* [Thoughtbot's Paperclip](https://github.com/thoughtbot/paperclip/)
* [Deep Liquid's JCrop](http://deepliquid.com/content/Jcrop.html)
* And Ryan Bates' [Railscast#182](http://railscasts.com/episodes/182-cropping-images/), which has inspired this gem