# Input taken from https://rcode5.wordpress.com/2013/06/07/custom-rspec-matchers-for-arrays/

RSpec::Matchers.define :be_monotonically_increasing do
  match do |actual|
    # for every pair in the array, derive a -1, 0, or 1 for the pair
    # 1 means the latter value is greater than the previous
    # -1 means the latter value is less than the previous
    # 0 means they are equal
    # to be monotonically increasing, every pair should be 1 or 0
    derivative = actual.each_cons(2).map { |x, y| y <=> x }
    derivative.all? { |v| v >= 0 }
  end

  failure_message_for_should do |actual|
    "expected array #{actual.inspect} to be monotonically increasing"
  end

  failure_message_for_should_not do |actual|
    "expected array #{actual.inspect} to not be monotonically increasing"
  end

  description do
    'be monotonically increasing'
  end
end

RSpec::Matchers.define :only_contain_values_between do |min, max|
  match do |actual|
    actual.all? { |v| v >= min && v <= max }
  end

  failure_message_for_should do |actual|
    "expected array #{actual.inspect} to only contain values between #{min} and #{max} (inclusive)"
  end

  failure_message_for_should_not do |actual|
    "expected array #{actual.inspect} to not only contain values between #{min} and #{max} (inclusive)"
  end

  description do
    'only contain values between'
  end
end
