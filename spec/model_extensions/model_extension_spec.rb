require "spec_helper"

describe "Model Extension" do

  before do
    @landscape         = Landscape.new(:name => "Mountains")
    @landscape.picture = open(mountains_img_path)
    @landscape.save

    @user = User.new(:name => "Bert", :email => "bert@sesame.street")
    @user.avatar    = open(bert_img_path)
    @user.signature = open(mountains_img_path)
    @user.save
  end


  it "clears the crop attributes" do
    @landscape.picture_crop_x = 0
    @landscape.picture_crop_y = 0
    @landscape.picture_crop_w = 400
    @landscape.picture_crop_h = 300
    @landscape.reset_crop_attributes_of(:picture)

    @landscape.picture_crop_x.should be(nil)
    @landscape.picture_crop_y.should be(nil)
    @landscape.picture_crop_w.should be(nil)
    @landscape.picture_crop_h.should be(nil)
  end


  it "crops images" do
    @landscape.picture_crop_x = 300
    @landscape.picture_crop_y = 200
    @landscape.picture_crop_w = 400
    @landscape.picture_crop_h = 300
    @landscape.save
    # Rounding to account for different versions of imagemagick
    compare_images(expected_mountains_img_path, @landscape.picture.path(:medium)).round(2).should eq(0.0)
  end


  it "defines an after update callback" do
    @landscape._update_callbacks.map do |e|
      e.instance_values['filter'].should eq(:reprocess_to_crop_picture_attachment) 
    end
  end


  it "includes accessors to the model" do
    %w{crop_x crop_y crop_w crop_h original_w original_h box_w aspect}.each do |m|
      @landscape.should respond_to(:"picture_#{m}")
      @landscape.should respond_to(:"picture_#{m}=")
    end
  end

  
  it "knows when to crop" do
    @landscape.cropping?(:picture).should be(false)
    @landscape.picture_crop_x = 0
    @landscape.picture_crop_y = 0
    @landscape.picture_crop_w = 400
    @landscape.picture_crop_h = 300
    @landscape.cropping?(:picture).should be(true)
  end


  it "normalizes aspect ratio" do 
    Landscape.normalize_aspect(4..3).should     eq(4..3)
    Landscape.normalize_aspect("4:3").should    eq(4..3)
    Landscape.normalize_aspect("4".."3").should eq(4..3)
    Landscape.normalize_aspect(4.0..3.0).should eq(4..3)
    Landscape.normalize_aspect(false).should    eq(false)
    Landscape.normalize_aspect(nil).should      eq(1..1)
    Landscape.normalize_aspect(true).should     eq(1..1)
    Landscape.normalize_aspect("foo").should    eq(1..1)
  end


  it "registers the post processor" do
    definitions = if Landscape.respond_to?(:attachment_definitions)
      Landscape.attachment_definitions
    else
      Paperclip::AttachmentRegistry.definitions_for(Landscape)
    end

    definitions[:picture][:processors].should eq([:papercrop])
  end


  it "returns image properties" do
    @landscape.picture_aspect.should eq(4.0 / 3.0)

    @landscape.image_geometry(:picture).width.should  eq(1024)
    @landscape.image_geometry(:picture).height.should eq(768)
  end


  it "returns image geometry for two attachments" do
    @user.image_geometry(:avatar).width.should              eq(900)
    @user.image_geometry(:avatar).height.should             eq(900)
    @user.image_geometry(:avatar, :medium).width.should     eq(200)
    @user.image_geometry(:avatar, :medium).height.should    eq(200)
    @user.image_geometry(:signature).width.should           eq(1024)
    @user.image_geometry(:signature).height.should          eq(768)
    @user.image_geometry(:signature, :medium).width.should  eq(496)
    @user.image_geometry(:signature, :medium).height.should eq(279)
  end


  it "sanitizes processor" do  
    Papercrop.expects(:log).with('[papercrop] picture crop w/h/x/y were non-integer. Error: invalid value for Integer(): "evil code"').twice
  
    @landscape.picture_crop_x = "evil code"
    @landscape.picture_crop_y = 200
    @landscape.picture_crop_w = 400
    @landscape.picture_crop_h = 300
    @landscape.save
  end


  it "returns url for s3 storage" do
    @landscape.picture.expects(:url).returns("http://some-aws-s3-storage-url").once
    @landscape.picture.expects(:options).returns(:storage => :s3).once
    Paperclip::Geometry.expects(:from_file).with("http://some-aws-s3-storage-url").once

    @landscape.image_geometry(:picture)
  end


  it "returns url for fog storage" do
    @landscape.picture.expects(:url).returns("http://some-aws-s3-fog-storage-url").once
    @landscape.picture.expects(:options).returns(:storage => :fog).once
    Paperclip::Geometry.expects(:from_file).with("http://some-aws-s3-fog-storage-url").once

    @landscape.image_geometry(:picture)
  end
end