require "rirera/engine"
require "colorize"
require "yaml"
require_relative "rirera/order"

module Rirera
  CONFIG = YAML.load_file(File.join(File.expand_path("..", File.dirname(__FILE__)),"config/brokers.yml"))

  extend self
  # Returns a valid broker or nil
  # Params:
  # +broker+:: +String+ Name of the broker
  def get_broker(broker)
    unless Rirera::CONFIG['broker'][broker].nil?
      broker
    else
      nil
    end
  end

  # Evaluates a stop loss
  # Params:
  # +actual_price+:: +Float+ or +Fixnum that represents the actual price
  # +stop_loss+:: +Float+ or +Fixnum that represents the stop loss
  def stop_loss(actual_price, stop_loss)
    if stop_loss >= actual_price
      nil
    else
      stop_loss
    end
  end

  # Sanity checks a user input
  # Params:
  # +num+:: +STDIN+ User Input
  def gets_sanity(num)
    num.chomp!.gsub!(",",".")
    # only allow int and float
    unless is_numeric?(num)
      nil
    else
      num.to_f
    end
  end

  # Validates a numeric
  # Params:
  # +s+:: +String+ which will be casted as a +Float+
  def is_numeric?(s)
    !!Float(s) rescue false
  end
end
