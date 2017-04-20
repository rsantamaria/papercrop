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

    expect(@landscape.picture_crop_x).to be(nil)
    expect(@landscape.picture_crop_y).to be(nil)
    expect(@landscape.picture_crop_w).to be(nil)
    expect(@landscape.picture_crop_h).to be(nil)
  end


  it "crops images" do
    @landscape.picture_crop_x = 300
    @landscape.picture_crop_y = 200
    @landscape.picture_crop_w = 400
    @landscape.picture_crop_h = 300
    @landscape.save
    # Rounding to account for different versions of imagemagick
    expect(compare_images(expected_mountains_img_path, @landscape.picture.path(:medium)).round(2)).to eq(0.0)
  end


  it "defines an after update callback" do
    @landscape._update_callbacks.map do |e|
      expect(e.instance_values['filter']).to eq(:reprocess_to_crop_picture_attachment) 
    end
  end


  it "includes accessors to the model" do
    %w{crop_x crop_y crop_w crop_h original_w original_h box_w aspect}.each do |m|
      expect(@landscape).to respond_to(:"picture_#{m}")
      expect(@landscape).to respond_to(:"picture_#{m}=")
    end
  end

  
  it "knows when to crop" do
    expect(@landscape.cropping?(:picture)).to be(false)
    @landscape.picture_crop_x = 0
    @landscape.picture_crop_y = 0
    @landscape.picture_crop_w = 400
    @landscape.picture_crop_h = 300
    expect(@landscape.cropping?(:picture)).to be(true)
  end


  it "normalizes aspect ratio" do 
    expect(Landscape.normalize_aspect(4..3)).to     eq(4..3)
    expect(Landscape.normalize_aspect("4:3")).to    eq(4..3)
    expect(Landscape.normalize_aspect("4".."3")).to eq(4..3)
    expect(Landscape.normalize_aspect(4.0..3.0)).to eq(4..3)
    expect(Landscape.normalize_aspect(false)).to    eq(false)
    expect(Landscape.normalize_aspect(nil)).to      eq(1..1)
    expect(Landscape.normalize_aspect(true)).to     eq(1..1)
    expect(Landscape.normalize_aspect("foo")).to    eq(1..1)
  end


  it "registers the post processor" do
    definitions = retrieve_attachment_definitions_for(Landscape)

    expect(definitions[:picture][:processors]).to eq([:papercrop])
  end


  it "does not register the processor if it's already there" do
    Landscape.has_attached_file :processed, :styles => {:medium => "200x200#"}, :processors => [:papercrop, :rotator]
    Landscape.crop_attached_file :processed

    definitions = retrieve_attachment_definitions_for(Landscape)

    expect(definitions[:processed][:processors]).to eq([:papercrop, :rotator])

    Landscape._update_callbacks.delete_if {|e| e.instance_values['filter'] == :reprocess_to_crop_processed_attachment } 
  end


  it "returns image properties" do
    expect(@landscape.picture_aspect).to eq(4.0 / 3.0)

    expect(@landscape.image_geometry(:picture).width).to  eq(1024)
    expect(@landscape.image_geometry(:picture).height).to eq(768)
  end


  it "returns image geometry for two attachments" do
    expect(@user.image_geometry(:avatar).width).to              eq(900)
    expect(@user.image_geometry(:avatar).height).to             eq(900)
    expect(@user.image_geometry(:avatar, :medium).width).to     eq(200)
    expect(@user.image_geometry(:avatar, :medium).height).to    eq(200)
    expect(@user.image_geometry(:signature).width).to           eq(1024)
    expect(@user.image_geometry(:signature).height).to          eq(768)
    expect(@user.image_geometry(:signature, :medium).width).to  eq(496)
    expect(@user.image_geometry(:signature, :medium).height).to eq(279)
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