require "RMagick"

def compare_images(test_image_path, cropped_image_path)
  test_img   = Magick::Image::read(test_image_path).first
  target_img = Magick::Image::read(cropped_image_path).first
  
  test_img.compare_channel(target_img, Magick::MeanAbsoluteErrorMetric).second
end


def mountains_img_path
  "spec/fixtures/mountains.jpg"
end


def expected_mountains_img_path
  "spec/fixtures/mountains_expected_result.jpg"
end


def bert_img_path
  "spec/fixtures/bert.jpg"
end