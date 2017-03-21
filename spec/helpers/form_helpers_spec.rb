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

    assert_select @box.root, 'input#landscape_picture_original_w[value="1024"]'
    assert_select @box.root, 'input#landscape_picture_original_h[value="768"]'
    assert_select @box.root, 'input#picture_crop_x'
    assert_select @box.root, 'input#picture_crop_y'
    assert_select @box.root, 'input#picture_crop_w'
    assert_select @box.root, 'input#picture_crop_h'

    assert_select @box.root, 'div#picture_cropbox' do
      assert_select 'img', :src => @landscape.picture.path(:original)
    end

    div = assert_select(@box.root, 'div#picture_cropbox').last
    div["data-aspect-ratio"].should eq("1.3333333333333333")
    div["data-box-width"].should eq("1024")
  end


  it "builds the crop box with unlocked aspect flag" do
    form_for @landscape do |f|
      @box = f.cropbox(:picture, :width => 400, :aspect_ratio => false)
    end
    @box = HTML::Document.new(@box)

    div = assert_select(@box.root, 'div#picture_cropbox').last
    div["data-aspect-ratio"].should eq("false")
  end


  it "builds the crop box with jcrop options" do
    form_for @landscape do |f|
      @box = f.cropbox(:picture, :width => 400, :aspect_ratio => 1.5, :set_select => [50, 50, 400, 300])
    end
    @box = HTML::Document.new(@box)

    div = assert_select(@box.root, 'div#picture_cropbox').last
    div["data-aspect-ratio"].should eq("1.5")
    div["data-set-select"].should eq("[50,50,400,300]")
    div["data-box-width"].should eq("400")
  end


  it "builds an empty box if there's no attachment" do 
    @landscape.picture = nil

    form_for @landscape do |f|
      @box = f.cropbox(:picture, :width => 400)
    end
    @box = HTML::Document.new(@box)

    assert_select @box.root, 'div#picture_cropbox img', :count => 0
    assert_select @box.root, 'div#picture_cropbox_blank'
  end


  it "builds the preview box" do
    form_for @landscape do |f|
      @box = f.crop_preview(:picture)
    end
    @box = HTML::Document.new(@box)

    assert_select @box.root, 'div#picture_crop_preview_wrapper[style="width:100px; height:75px; overflow:hidden"]' do
      assert_select "img#picture_crop_preview[src=\"#{@landscape.picture.url(:original)}\"]"
      assert_select "img#picture_crop_preview[style=\"max-width:none; max-height:none\"]"
    end
  end


  it "builds the preview box with different width" do
    form_for @landscape do |f|
      @box = f.crop_preview(:picture, :width => 40)
    end
    @box = HTML::Document.new(@box)

    assert_select @box.root, 'div#picture_crop_preview_wrapper[style="width:40px; height:30px; overflow:hidden"]'
  end
end
