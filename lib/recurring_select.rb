require "recurring_select/engine"
require "ice_cube"

module RecurringSelect

  def self.dirty_hash_to_rule(params)
    if params.is_a? IceCube::Rule
      params
    else
      if params.is_a?(String)
        params = JSON.parse(params)
      end

      params = params.symbolize_keys
      rules_hash = filter_params(params)

      IceCube::Rule.from_hash(rules_hash)
    end
  end

  def self.is_valid_rule?(possible_rule)
    return true if possible_rule.is_a?(IceCube::Rule)
    return false if possible_rule.blank?

    if possible_rule.is_a?(String)
      begin
        JSON.parse(possible_rule)
        return true
      rescue JSON::ParserError
        return false
      end
    end

    # TODO: this should really have an extra step where it tries to perform the final parsing
    return true if possible_rule.is_a?(Hash)

    false #only a hash or a string of a hash can be valid
  end

  private

  def self.filter_params(params)
    params.reject!{|key, value| value.blank? || value=="null" }

    params[:interval] = params[:interval].to_i if params[:interval]
    params[:week_start] = params[:week_start].to_i if params[:week_start]

    params[:validations] ||= {}
    params[:validations].symbolize_keys!

    if params[:validations][:day]
      params[:validations][:day] = params[:validations][:day].collect(&:to_i)
    end

    if params[:validations][:hour_of_day] && params[:validations][:hour_of_day].length > 0
      params[:validations][:hour_of_day] = params[:validations][:hour_of_day].collect(&:to_i)
    end

    if params[:validations][:minute_of_hour] && params[:validations][:minute_of_hour].length > 0
      params[:validations][:minute_of_hour] = params[:validations][:minute_of_hour].collect(&:to_i)
    end

    if params[:validations][:day_of_month]
      params[:validations][:day_of_month] = params[:validations][:day_of_month].collect(&:to_i)
    end

    if params[:validations][:month_of_year]
      params[:validations][:month_of_year] = params[:validations][:month_of_year].collect(&:to_i)
    end

    # this is soooooo ugly
    if params[:validations][:day_of_week]
      params[:validations][:day_of_week] ||= {}
      if params[:validations][:day_of_week].length > 0 and not params[:validations][:day_of_week].keys.first =~ /\d/
        params[:validations][:day_of_week].symbolize_keys!
      else
        originals = params[:validations][:day_of_week].dup
        params[:validations][:day_of_week] = {}
        originals.each{|key, value|
          params[:validations][:day_of_week][key.to_i] = value
        }
      end
      params[:validations][:day_of_week].each{|key, value|
        params[:validations][:day_of_week][key] = value.collect(&:to_i)
      }
    end

    if params[:validations][:day_of_year]
      params[:validations][:day_of_year] = params[:validations][:day_of_year].collect(&:to_i)
    end

    params
  end
end
