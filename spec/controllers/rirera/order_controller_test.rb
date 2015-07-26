require 'test_helper'

module Rirera
  class OrderControllerTest < ActionController::TestCase
    test "should get get" do
      get :get
      assert_response :success
    end

  end
end
