require 'colorize'
require 'yaml'

module Rirera
  CONFIG = YAML.load_file(File.join(File.expand_path("..", File.dirname(__FILE__)),"conf/rirera.yml"))

  class Order
    attr_accessor :broker, :volume, :target, :actual, :stop

    def initialize(broker, volume, target, actual, stop)
      @broker = Rirera.get_broker(broker)
      @volume = volume
      @target = target
      @actual = actual
      @stop = stop
    end

    def get_rrr
      chance = @target - @actual
      risk = @actual - @stop
      (chance/risk).round(1)
    end

    def get_total_commission
      # calculate order pricing
      basic_price = Rirera::CONFIG['broker'][@broker]['basic_price']
      commission_rate = Rirera::CONFIG['broker'][@broker]['commission_rate']
      volume_rate_buy = (get_amount * @actual * commission_rate).round(2)
      volume_rate_sell = (get_amount * @target * commission_rate).round(2)
      total_commission = 0.0

      [volume_rate_buy, volume_rate_sell].each do |vr|
        if (vr + basic_price) > Rirera::CONFIG['broker'][@broker]['min_rate']
          if (vr + basic_price) > Rirera::CONFIG['broker'][@broker]['max_rate']
            total_commission += Rirera::CONFIG['broker'][@broker]['max_rate']
          else
            total_commission += (basic_price + vr)
          end
        else
          total_commission += Rirera::CONFIG['broker'][@broker]['min_rate']
        end
      end
      total_commission.round(2)
    end

    def get_amount
      (@volume/@actual).round
    end

    def get_max_gain
      ((get_amount * @target) - @volume - get_total_commission).round(2)
    end

    def get_loss
      ((@volume-(get_amount*@stop)) + get_total_commission).round(2)
    end

    def get_break_even
      ((@volume + get_total_commission) / get_amount).round(2)
    end

    def print_result
      12.times { print "#" }
      print "\n# RRR: "
      print "#{get_rrr}".yellow
      puts " #"
      12.times { print "#" }
      2.times { puts "" }
      puts "Volume: #{@volume}"
      puts "Amount: #{get_amount}"
      puts "Gain: #{get_max_gain}".green
      puts "Loss: #{get_loss}".red
      puts "Commission: #{get_total_commission}".magenta
      puts "Break Even: #{get_break_even}".blue
    end
  end

  def Rirera.get_broker(broker)
    unless Rirera::CONFIG['broker'][broker].nil?
      broker
    else
      nil
    end
  end


  def Rirera.stop_loss(actual_price, stop_loss)
    if stop_loss >= actual_price
      nil
    else
      stop_loss
    end
  end

  def Rirera.sanity_check(num)
    num.chomp!.gsub!(",",".")
    # only allow int and float
    unless Rirera.is_numeric?(num)
      nil
    else
      num.to_f
    end
  end

  def Rirera.is_numeric?(s)
    !!Float(s) rescue false
  end
end
