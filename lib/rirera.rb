require 'colorize'
require 'yaml'

class Rirera
  attr_accessor :broker, :volume, :target, :actual, :stop

  def initialize
    @conf = load_config
  end

  def get_broker(broker)
    unless @conf['broker'][broker].nil?
      broker
    else
      abort "Not a valid broker"
    end
  end

  def decorate
    12.times do
      print "#"
    end
  end

  def print_title
    puts "€$€$€$€$€$€$€$€$€$€$€"
    puts "€ Risk Reward Ratio €"
    puts "€$€$€$€$€$€$€$€$€$€$€"
    puts "|               /    "
    puts "|      _  /\\_  /    "
    puts "|     / \\/   \\/    "
    puts "|  /\\/              "
    puts "|_/                  "
    puts "L___________________ "
    puts ""
  end

  def print_rrr
    decorate
    print "\n# RRR: "
    print "#{get_rrr}".yellow
    puts " #"
    decorate
  end

  def print_result
    print_rrr
    puts ""
    puts ""
    puts "Volume: #{@volume}"
    puts "Amount: #{get_amount}"
    puts "Gain: #{get_max_gain}".green
    puts "Loss: #{get_loss}".red
    puts "Commission: #{get_total_commission}".magenta
    puts "Break Even: #{get_break_even}".blue
  end

  def load_config
    YAML.load_file(File.join(File.expand_path("..", File.dirname(__FILE__)),"conf/rirera.yml"))
  end

  def stop_loss(actual_price, stop_loss)
    if stop_loss >= actual_price
      nil
    else
      stop_loss
    end
  end

  def sanity_check(num)
    num.chomp!.gsub!(",",".")
    # only allow int and float
    unless is_numeric?(num)
      puts "Wrong input"
      abort
    else
      num.to_f
    end
  end

  def is_numeric?(s)
    !!Float(s) rescue false
  end

  def get_rrr
    chance = @target - @actual
    risk = @actual - @stop
    (chance/risk).round(1)
  end

  def get_total_commission
    # calculate order pricing
    basic_price = @conf['broker'][@broker]['basic_price']
    commission_rate = @conf['broker'][@broker]['commission_rate']
    volume_rate_buy = (get_amount * @actual * commission_rate).round(2)
    volume_rate_sell = (get_amount * @target * commission_rate).round(2)
    total_commission = 0.0

    [volume_rate_buy, volume_rate_sell].each do |vr|
      if (vr + basic_price) > @conf['broker'][@broker]['min_rate']
        if (vr + basic_price) > @conf['broker'][@broker]['max_rate']
          total_commission += @conf['broker'][@broker]['max_rate']
        else
          total_commission += (basic_price + vr)
        end
      else
        total_commission += @conf['broker'][@broker]['min_rate']
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

end
