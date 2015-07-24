require 'test_helper'
require "stringio"

class RireraTest < ActiveSupport::TestCase
  test "get broker" do
    assert_equal Rirera.get_broker("consors"), "consors"
    assert_nil Rirera.get_broker("I am broke")
  end

  test "stop loss" do
    assert_equal Rirera.stop_loss(3.14, 3.00), 3.00
    assert_nil Rirera.stop_loss(3.00, 3.14)
  end

  test "gets sanity check" do
    assert_nil Rirera.gets_sanity(get_input(false))
    assert_equal Rirera.gets_sanity(get_input(true)), 3.14
  end

  test "is numeric" do
    assert Rirera.is_numeric?(3.14)
    assert_not Rirera.is_numeric?("NAN")
  end

  private
  # Simulate some User Input
  def get_input(valid)
    case valid
    when true
      StringIO.new("3,14\n").gets
    when false
      StringIO.new("NAN\n").gets
    end
  end
end
