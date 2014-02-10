require "spec_helper"

describe "Image crop" do

  it "crops an image" do
    visit landscapes_path

    click_link "New Landscape"

    fill_in      "Name", :with => "Mountains"
    attach_file  "Picture", "test_app/test/fixtures/matterhorn.jpg"
    click_button "Create Landscape"

    page.should have_css("#picture_crop_preview_wrapper")
    page.should have_css("#picture_crop_preview")
    page.should have_css("#picture_cropbox")

    page.should have_css("#landscape_picture_original_w")

    find("#landscape_picture_original_w").value.should eq("1024.0")
    find("#landscape_picture_original_h").value.should eq("768.0")
    find("#landscape_picture_box_w").value.should      eq("600")
    find("#picture_aspect").value.should               eq((4.0 / 3.0).to_s)

    find("#picture_crop_x").set "300.0"
    find("#picture_crop_y").set "200.0"
    find("#picture_crop_w").set "400"
    find("#picture_crop_h").set "300"

    click_button "Crop image"
    
    compare_images(CROPPED_IMG_PATH, Landscape.last.picture.path(:medium)).round(2).should eq(0.0)
  end
end