# # # # # # #
# Class RRR #
# # # # # # #
require 'colorize'

class RRR
  def initialize(broker)
    @broker = broker
  end

  def usage
    puts "Usage:"
    puts "./rirera broker_name"
    exit
  end

  def get_broker(broker, conf)
    unless conf['broker'][@broker].nil?
      @broker
    else
      abort "Not a valid broker"
    end
  end

  def decorate
    12.times do
      print "#"
    end
  end

  def print_rrr(rrr)
    decorate
    print "\n# RRR: "
    print "#{rrr}".yellow
    puts " #"
    decorate
  end

  def print_result(volume, amount, max_gain, loss, total_commission, break_even_price)
    puts ""
    puts ""
    puts "Volume: #{volume}"
    puts "Amount: #{amount}"
    puts "Gain: #{max_gain}".green
    puts "Loss: #{loss}".red
    puts "Commission: #{total_commission}".magenta
    puts "Break Even: #{break_even_price}".blue
    puts ""
    puts "Again? (y/n)"
  end

  def test_input(actual_price, stop_loss)
    abort "Stop Loss has to be lower than Price" unless stop_loss < actual_price
  end

  def get_total_commission(amount, actual_price, target_price, conf, broker)
    # calculate order pricing
    basic_price = conf['broker'][broker]['basic_price']
    commission_rate = conf['broker'][broker]['commission_rate']
    volume_rate_buy = (amount * actual_price * commission_rate).round(2)
    volume_rate_sell = (amount * target_price * commission_rate).round(2)
    total_commission = 0.0

    [volume_rate_buy, volume_rate_sell].each do |vr|
      if (vr + basic_price) > conf['broker'][broker]['min_rate']
        if (vr + basic_price) > conf['broker'][broker]['max_rate']
          total_commission += conf['broker'][broker]['max_rate']
        else
          total_commission += (basic_price + vr)
        end
      else
        total_commission += conf['broker'][broker]['min_rate']
      end
    end
    total_commission.round(2)
  end

  def get_break_even(total_commission, volume, amount)
    ((volume + total_commission) / amount).round(2)
  end
end
