require "spec_helper"

describe "Papercrop::Cropbox" do

  before do
    @landscape         = Landscape.new(:name => "Mountains")
    @landscape.picture = open(mountains_img_path)
    @landscape.save

    @cropbox = Papercrop::Cropbox.new(@landscape, :picture)
  end


  it "sets up geometry" do
    expect(@cropbox.instance_variable_get(:@geometry).kind_of?(Paperclip::Geometry)).to be(true)
    expect(@cropbox.geometry?).to be(true)
    expect(@cropbox.original_width).to eq(1024)
    expect(@cropbox.original_height).to eq(768)
  end


  it "doesn't crash if the attachment is blank" do
    @landscape.picture = nil
    cropbox = Papercrop::Cropbox.new(@landscape, :picture)

    expect(cropbox.geometry?).to be(false)
  end


  it "parses jcrop opts" do
    opts = @cropbox.parse_jcrop_opts({})

    expect(opts[:aspect_ratio]).to eq(1.3333333333333333)
    expect(opts[:set_select]).to eq([0, 0, 512, 384])

    opts = @cropbox.parse_jcrop_opts(:width => 1200, :aspect => 1.5, :set_select => [50, 50, 400, 300], :max_size => [1200, 900], :bg_color => '#884433')

    expect(opts[:box_width]).to eq(1200)
    expect(opts[:aspect_ratio]).to eq(1.5)
    expect(opts[:set_select]).to eq([50, 50, 400, 300])
    expect(opts[:max_size]).to eq([1200, 900])
    expect(opts[:bg_color]).to eq('#884433')

    opts = @cropbox.parse_jcrop_opts(:box_width => 1200, :aspect => false)

    expect(opts[:box_width]).to eq(1200)
    expect(opts[:aspect_ratio]).to be(false)
  end
end