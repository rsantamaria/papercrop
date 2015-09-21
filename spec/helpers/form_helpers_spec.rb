require "spec_helper"

describe "Form Helpers" do

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
    @box = HTML::Document.new(@box)

    assert_select @box.root, 'input#landscape_picture_original_w', :value => "1024.0"
    assert_select @box.root, 'input#landscape_picture_original_h', :value => "768.0"
    assert_select @box.root, 'input#landscape_picture_box_w',      :value => "1024.0"
    assert_select @box.root, 'input#picture_aspect',               :value => @landscape.picture_aspect.to_s
    assert_select @box.root, 'input#picture_crop_x'
    assert_select @box.root, 'input#picture_crop_y'
    assert_select @box.root, 'input#picture_crop_w'
    assert_select @box.root, 'input#picture_crop_h'

    assert_select @box.root, 'div#picture_cropbox' do
      assert_select 'img', :src => @landscape.picture.path(:original)
    end
  end


  it "builds the crop box with different width" do
    form_for @landscape do |f|
      @box = f.cropbox(:picture, :width => 400)
    end
    @box = HTML::Document.new(@box)

    assert_select @box.root, 'input#landscape_picture_box_w', :value => "400"
  end


  it "builds the preview box" do
    form_for @landscape do |f|
      @box = f.crop_preview(:picture)
    end
    @box = HTML::Document.new(@box)

    assert_select @box.root, 'div#picture_crop_preview_wrapper', :style => "width:100px; height:75px; overflow:hidden" do
      assert_select 'img#picture_crop_preview', :src => @landscape.picture.path(:original)
    end
  end


  it "build the preview box with different width" do
    form_for @landscape do |f|
      @box = f.crop_preview(:picture, :width => 40)
    end
    @box = HTML::Document.new(@box)

    assert_select @box.root, 'div#picture_crop_preview_wrapper', :style => "width:40px; height:30px; overflow:hidden"
  end
end