class FakeModel
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  # include ActiveModel::MassAssignmentSecurity

  attr_accessor :recurring_rules

  def current_existing_rule
    IceCube::Rule.monthly.day_of_month(-1).to_hash
  end

  def current_custom_rule
    IceCube::Rule.daily(2).hour_of_day(10).minute_of_hour(30).to_hash
  end

  def non_recurring_rule; 1; end
  def persisted?; false; end
end
