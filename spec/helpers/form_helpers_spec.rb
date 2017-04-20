require "spec_helper"

describe "Form Helpers" do
  include RSpecHtmlMatchers

  before do
    @landscape         = Landscape.new(:name => "Mountains")
    @landscape.picture = open(mountains_img_path)
    @landscape.save

    @box = nil
  end


  it "builds the crop box" do
    form_for @landscape do |f|
      @box = f.cropbox(:picture)
    end

    expect(@box).to have_tag "input#landscape_picture_original_w", with: { value: "1024" }
    expect(@box).to have_tag "input#landscape_picture_original_h", with: { value: "768" }
    expect(@box).to have_tag "input#picture_crop_x"
    expect(@box).to have_tag "input#picture_crop_y"
    expect(@box).to have_tag "input#picture_crop_w"
    expect(@box).to have_tag "input#picture_crop_h"

    expect(@box).to have_tag 'div#picture_cropbox' do
      with_tag 'img', with: { src: @landscape.picture.url(:original) }
    end

    expect(@box).to have_tag 'div#picture_cropbox', with: { "data-aspect-ratio": "1.3333333333333333", "data-box-width": "1024"}
  end


  it "builds the crop box with unlocked aspect flag" do
    form_for @landscape do |f|
      @box = f.cropbox(:picture, :width => 400, :aspect_ratio => false)
    end
    expect(@box).to have_tag 'div#picture_cropbox', with: { "data-aspect-ratio": "false"}
  end


  it "builds the crop box with jcrop options" do
    form_for @landscape do |f|
      @box = f.cropbox(:picture, :width => 400, :aspect_ratio => 1.5, :set_select => [50, 50, 400, 300])
    end

    expect(@box).to have_tag 'div#picture_cropbox', with: {
      "data-aspect-ratio": "1.5",
      "data-set-select": "[50,50,400,300]",
      "data-box-width": "400"
    }
  end


  it "builds an empty box if there's no attachment" do
    @landscape.picture = nil

    form_for @landscape do |f|
      @box = f.cropbox(:picture, :width => 400)
    end

    expect(@box).to_not have_tag 'div#picture_cropbox img'
    expect(@box).to have_tag 'div#picture_cropbox_blank'
  end


  it "builds the preview box" do
    form_for @landscape do |f|
      @box = f.crop_preview(:picture)
    end

    expect(@box).to have_tag 'div#picture_crop_preview_wrapper[style="width:100px; height:75px; overflow:hidden"]' do
      with_tag 'img#picture_crop_preview', with: { src: @landscape.picture.url(:original), style: "max-width:none; max-height:none" }
    end
  end


  it "builds the preview box with different width" do
    form_for @landscape do |f|
      @box = f.crop_preview(:picture, :width => 40)
    end

    expect(@box).to have_tag 'div#picture_crop_preview_wrapper', with: { style: "width:40px; height:30px; overflow:hidden" }
  end
end
