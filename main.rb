# frozen_string_literal: true

def with_nondeterminism
  [
    proc do
      @first_time = true
      yield
    end.call,
    proc do
      @first_time = false
      yield
    end.call
  ]
end

@first_time = true

def choose2(a, b)
  if @first_time
    a
  else
    b
  end
end

result = with_nondeterminism do
  3 * choose2(5, 6)
end

puts result.to_s
# => [15, 18]
