module Rirera
  class Order
    attr_accessor :broker, :volume, :target, :actual, :stop

    def initialize(broker, volume, target, actual, stop)
      @broker = Rirera.get_broker(broker)
      @volume = volume
      @target = target
      @actual = actual
      @stop = stop
    end

    # Returns a Risk Reward Ratio +Float+
    def risk_reward_ratio
      chance = @target - @actual
      risk = @actual - @stop
      (chance/risk).round(1)
    end

    # Calculate the pricing for the Order
    # This is dependent on the normal Broker Rates defined in config/brokers.yml
    def get_total_commission
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

    # Return the amount of Securities
    def get_amount
      (@volume/@actual).round
    end

    # Return the maximum gain
    def get_max_gain
      ((get_amount * @target) - @volume - get_total_commission).round(2)
    end

    # Return the possible loss
    def get_loss
      ((@volume-(get_amount*@stop)) + get_total_commission).round(2)
    end

    # Return the break even
    def get_break_even
      ((@volume + get_total_commission) / get_amount).round(2)
    end
  end
end
