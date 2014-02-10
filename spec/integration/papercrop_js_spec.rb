require "spec_helper"

describe "Image crop with JS", :js => true do

  it "crops an image with javascript" do
    visit landscapes_path

    click_link "New Landscape"

    fill_in "Name", :with => "Mountains"
    find("#landscape_picture").native.send_keys(File.expand_path("../../../test_app/test/fixtures/matterhorn.jpg", __FILE__))
    click_button "Create Landscape"

    sleep 2
    page.execute_script("jcrop_api.setSelect([300, 200, 700, 500])")
    page.execute_script('if ($("#picture_crop_y").val() == "199"){$("#picture_crop_y").val("200")}')
    page.execute_script('if ($("#picture_crop_w").val() == "399"){$("#picture_crop_w").val("400")}')

    click_button "Crop image"

    sleep 1
    compare_images(CROPPED_IMG_PATH, Landscape.last.picture.path(:medium)).round(2).should eq(0.0)
  end


  it "crops an image by ajax call" do
    visit landscapes_path

    click_link "New Landscape"

    fill_in "Name", :with => "Mountains"
    find("#landscape_picture").native.send_keys(File.expand_path("../../../test_app/test/fixtures/matterhorn.jpg", __FILE__))
    click_button "Create Landscape"

    click_button "Crop image"
    click_link "Back"

    click_link "Crop"

    sleep 2
    page.execute_script("jcrop_api.setSelect([300, 200, 700, 500])")
    page.execute_script('if ($("#picture_crop_y").val() == "199"){$("#picture_crop_y").val("200")}')
    page.execute_script('if ($("#picture_crop_w").val() == "399"){$("#picture_crop_w").val("400")}')

    click_button "Crop image"

    sleep 1
    compare_images(CROPPED_IMG_PATH, Landscape.last.picture.path(:medium)).round(2).should eq(0.0)
  end
end