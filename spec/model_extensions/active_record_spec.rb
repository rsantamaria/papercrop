require "spec_helper"

describe "Active Record Extension" do

  before do
    @landscape         = Landscape.new(:name => "Mountains")
    @landscape.picture = open("test_app/test/fixtures/matterhorn.jpg")
    @landscape.save
  end


  after do
    @landscape.destroy
  end


  it "includes accessors to the model" do
    %w{crop_x crop_y crop_w crop_h original_w original_h box_w aspect}.each do |m|
      @landscape.should respond_to(:"picture_#{m}")
      @landscape.should respond_to(:"picture_#{m}=")
    end
  end


  it "registers the post processor" do
    @landscape.attachment_definitions[:picture][:processors].should eq([:cropper])
  end


  it "defines an after update callback" do
    @landscape._update_callbacks.map do |e|
      e.instance_values['filter'].should eq(:reprocess_to_crop_picture_attachment) 
    end
  end


  it "returns image properties" do
    @landscape.picture_aspect.should eq(4.0 / 3.0)

    @landscape.image_geometry(:picture).width.should  eq(1024.0)
    @landscape.image_geometry(:picture).height.should eq(768.0)
  end


  it "knows when to crop" do
    @landscape.cropping?(:picture).should be(false)
    @landscape.picture_crop_x = 0.0
    @landscape.picture_crop_y = 0.0
    @landscape.picture_crop_w = 400
    @landscape.picture_crop_h = 300
    @landscape.cropping?(:picture).should be(true)
  end


  it "crops images" do
    @landscape.picture_crop_x = 300.0
    @landscape.picture_crop_y = 200.0
    @landscape.picture_crop_w = 400
    @landscape.picture_crop_h = 300
    @landscape.save

    compare_images(CROPPED_IMG_PATH, @landscape.picture.path(:medium)).should eq(0.0)
  end
end