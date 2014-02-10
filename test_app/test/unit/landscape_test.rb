require_relative '../test_helper'

class LandscapeTest < ActiveSupport::TestCase

  test 'Fixture is valid' do
    Landscape.all.each do |landscape|
      assert landscape.valid?
    end
  end

end
