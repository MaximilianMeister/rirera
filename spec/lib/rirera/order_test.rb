require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup :initialize_order

  test "risk reward ratio" do
    assert_equal @order.risk_reward_ratio, 4.3
  end

  test "get total commission" do
    assert_equal @order.get_total_commission, 20.86
  end

  test "get amount" do
    assert_equal @order.get_amount, 637
  end

  test "get maximum gain" do
    assert_equal @order.get_max_gain, 361.52
  end

  test "get possible loss" do
    assert_equal @order.get_loss, 109.86
  end

  test "get break even" do
    assert_equal @order.get_break_even, 3.17
  end

  private
  def initialize_order
    @order = Rirera::Order.new("consors", 2000, 3.74, 3.14, 3.00)
  end
end
