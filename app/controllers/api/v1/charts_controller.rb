class Api::V1::ChartsController < Api::V1::BaseApiController
  before_action :set_merchandise_rate

  def effect_hour_candlestick_type_in_day
    result_json = {
      "0": [0, 0],
      "1": [0, 0],
      "2": [0, 0],
      "3": [0, 0],
      "4": [0, 0],
      "5": [0, 0],
      "6": [0, 0],
      "7": [0, 0],
      "8": [0, 0],
      "9": [0, 0],
      "10": [0, 0],
      "11": [0, 0],
      "12": [0, 0],
      "13": [0, 0],
      "14": [0, 0],
      "15": [0, 0],
      "16": [0, 0],
      "17": [0, 0],
      "18": [0, 0],
      "19": [0, 0],
      "20": [0, 0],
      "21": [0, 0],
      "22": [0, 0],
      "23": [0, 0]
    }

    @mr.hour_analytics.from_day_number(params["day_number"].to_i).pluck(:hour, :candlestick_type).each do |arr|
      if arr[1] == "increase"
        result_json[:"#{arr[0]}"][0] = result_json[:"#{arr[0]}"][0] + 1
      else
        result_json[:"#{arr[0]}"][1] = result_json[:"#{arr[0]}"][1] + 1
      end
    end

    render json: result_json
  end

  def highest_return_hour_in_day
    result_json = {
      "0": 0,
      "1": 0,
      "2": 0,
      "3": 0,
      "4": 0,
      "5": 0,
      "6": 0,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": 0,
      "11": 0,
      "12": 0,
      "13": 0,
      "14": 0,
      "15": 0,
      "16": 0,
      "17": 0,
      "18": 0,
      "19": 0,
      "20": 0,
      "21": 0,
      "22": 0,
      "23": 0
    }

    DayAnalytic.get_list_highest_hour_return(@mr.id, params["day_number"].to_i).each do |arr|
      result_json[:"#{arr[0]}"] = arr[1]
    end

    render json: result_json
  end

  private
  def set_merchandise_rate
    @mr = MerchandiseRate.find(params["merchandise_rate_id"])
  end
end
