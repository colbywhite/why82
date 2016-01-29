RSpec::Matchers.define :eq_record do |wins, losses, ties|
  match do |actual|
    total = wins + losses
    percentage = (total == 0) ? BigDecimal(0) : BigDecimal(wins) / BigDecimal(wins + losses)
    wins == actual.wins && losses == actual.losses && ties == actual.ties && percentage == actual.percentage
  end

  failure_message_for_should do |actual|
    "expected record: #{wins}-#{losses}-#{ties}; actual record: #{actual.to_string}"
  end

  failure_message_for_should_not do |actual|
    "actual record: #{actual.to_string} should not be #{wins}-#{losses}-#{ties}"
  end

  description do
    'equal record'
  end
end
