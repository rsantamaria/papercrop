require "spec_helper"

describe "RegExp Module" do

  it "recognizes a callback name" do
    assert "reprocess_to_crop_picture_attachment"    =~ Papercrop::RegExp::CALLBACK
    assert "reprocess_to_crop_thing1_attachment"     =~ Papercrop::RegExp::CALLBACK
    assert not("reprocess_to_crop_picture_atachment" =~ Papercrop::RegExp::CALLBACK)
    assert not("reprocess_to_crop_attachment"        =~ Papercrop::RegExp::CALLBACK)
  end


  it "parses aspects" do
    assert "1:1"  =~ Papercrop::RegExp::ASPECT
    assert "4:3"  =~ Papercrop::RegExp::ASPECT
    assert "10:3" =~ Papercrop::RegExp::ASPECT
    assert not("4:0"  =~ Papercrop::RegExp::ASPECT)
    assert not("0:4"  =~ Papercrop::RegExp::ASPECT)
    assert not("00:0" =~ Papercrop::RegExp::ASPECT)
    assert not("A:3"  =~ Papercrop::RegExp::ASPECT)
  end
end