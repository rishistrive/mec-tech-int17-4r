require 'test_helper'

class FoodShopTest < ActiveSupport::TestCase
  test "Save data for food vendors" do
    fl = FileLoad.new(filename: 'test/fixtures/files/food-vendors.csv')
    assert(fl.save, "save failed:  ")
    assert_equal(FoodShop.all.count, 5)
  end

  test "Save data for service vendors" do
    fl = FileLoad.new(filename: 'test/fixtures/files/service-vendors.csv', file_format: 'service-vendors')
    assert(fl.save, "save failed:  ")
    assert_equal(FoodShop.all.count, 6)
  end

  test "Blank code and Blank name check" do
    fs1 = FoodShop.new(code: "test code")
    assert_not(fs1.save, "blank name saved")
    assert(fs1.errors[:name].join(", ").include?('blank'), "blank-name error did not include 'blank'")

    fs2 = FoodShop.new(name: "test name")
    assert_not(fs2.save, "blank code saved")
    assert(fs2.errors[:code].join(", ").include?('blank'), "blank-code error did not include 'blank'")
  end
end
